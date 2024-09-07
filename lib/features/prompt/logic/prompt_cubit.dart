import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_with_gen_ai/core/utils/enums.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/prompt_model.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/recipe_model.dart';
import 'package:recipes_with_gen_ai/features/prompt/service/gemini_service.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  PromptCubit({
    required this.model,
  }) : super(PromptInitial(promptModel: PromptModel.empty()));

  final GenerativeModel model;
  TextEditingController promptTextController = TextEditingController();

  String get badImageFailure =>
      'The recipe request either does not contain images, or does not contain '
      'images of food items. I cannot recommend a recipe.';

  void addImage(XFile image) {
    final prompt = state.promptModel;
    prompt.images.insert(0, image);
    emit(EditingPrompt(promptModel: prompt));
  }

  void addAdditionalPromptContext(String text) {
    final existingInputs = state.promptModel.additionalTextInputs;
    state.promptModel.copyWith(additionalTextInputs: [...existingInputs, text]);
  }

  void removeImage(XFile image) {
    final prompt = state.promptModel;
    prompt.images.removeWhere((el) => el.path == image.path);
    emit(EditingPrompt(promptModel: prompt));
  }

  void resetPrompt() {
    emit(PromptInitial(promptModel: PromptModel.empty()));
  }

  // Creates an ephemeral prompt with additional text that the user shouldn't be
  // concerned with to send to Gemini, such as formatting.
  PromptModel buildPrompt() {
    return PromptModel(
      images: state.promptModel.images,
      textInput: mainPrompt,
      basicIngredients: state.promptModel.selectedBasicIngredients,
      cuisines: state.promptModel.selectedCuisines,
      dietaryRestrictions: state.promptModel.selectedDietaryRestrictions,
      additionalTextInputs: [format],
    );
  }

  void addBasicIngredients(Set<BasicIngredientsFilter> ingredients) {
    final prompt = state.promptModel.copyWith(basicIngredients: ingredients);
    emit(EditingPrompt(promptModel: prompt));
  }

  void addCategoryFilters(Set<CuisineFilter> categories) {
    final prompt = state.promptModel.copyWith(cuisineSelections: categories);
    emit(EditingPrompt(promptModel: prompt));
  }

  void addDietaryRestrictionFilter(
    Set<DietaryRestrictionsFilter> restrictions,
  ) {
    final prompt =
        state.promptModel.copyWith(dietaryRestrictions: restrictions);
    emit(EditingPrompt(promptModel: prompt));
  }

  Future<void> submitPrompt() async {
    emit(PromptLoading(promptModel: state.promptModel));
    // Create an ephemeral PromptData, preserving the user prompt data without
    // adding the additional context to it.

    final prompt = buildPrompt();

    try {
      final content = await GeminiService.generateContent(model, prompt);

      // handle no image or image of not-food
      if (content.text != null && content.text!.contains(badImageFailure)) {
        emit(
          PromptError(
            message: badImageFailure,
            promptModel: state.promptModel,
          ),
        );
      } else {
        emit(
          PromptLoaded(
            recipe: Recipe.fromGeneratedContent(content),
            promptModel: state.promptModel,
          ),
        );
      }
    } catch (error) {
      emit(
        PromptError(
          message: 'Failed to reach Gemini. \n\n$error',
          promptModel: state.promptModel,
        ),
      );
      if (kDebugMode) {
        print(error);
      }
    }
  }

  String get mainPrompt {
    return '''
You are a Cat who's a chef that travels around the world a lot, and your travels inspire recipes.

Recommend a recipe for me based on the provided image.
The recipe should only contain real, edible ingredients.
If there are no images attached, or if the image does not contain food items, respond exactly with: $badImageFailure

Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.
I'm in the mood for the following types of cuisine: ${state.promptModel.cuisines},
I have the following dietary restrictions: ${state.promptModel.dietaryRestrictions}
Optionally also include the following ingredients: ${state.promptModel.ingredients}
Do not repeat any ingredients.

After providing the recipe, add an descriptions that creatively explains why the recipe is good based on only the ingredients used in the recipe.  Tell a short story of a travel experience that inspired the recipe.
List out any ingredients that are potential allergens.
Provide a summary of how many people the recipe will serve and the the nutritional information per serving.

${promptTextController.text.isNotEmpty ? promptTextController.text : ''}
''';
  }

  final String format = r'''
Return the recipe as valid JSON using the following structure:
{
  "id": $uniqueId,
  "title": $recipeTitle,
  "ingredients": $ingredients,
  "description": $description,
  "instructions": $instructions,
  "cuisine": $cuisineType,
  "allergens": $allergens,
  "servings": $servings,
  "nutritionInformation": {
    "calories": "$calories",
    "fat": "$fat",
    "carbohydrates": "$carbohydrates",
    "protein": "$protein",
  },
}
  
uniqueId should be unique and of type String. 
title, description, cuisine, and servings should be of String type. 
ingredients, allergens and instructions should be of type List<String>.
nutritionInformation should be of type Map<String, String>.
''';

  @override
  Future<void> close() {
    promptTextController.dispose();
    return super.close();
  }
}
