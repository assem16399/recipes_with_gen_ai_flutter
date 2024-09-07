import 'package:image_picker/image_picker.dart';
import 'package:recipes_with_gen_ai/core/utils/enums.dart';

class PromptModel {
  PromptModel({
    required this.images,
    required this.textInput,
    Set<BasicIngredientsFilter>? basicIngredients,
    Set<CuisineFilter>? cuisines,
    Set<DietaryRestrictionsFilter>? dietaryRestrictions,
    List<String>? additionalTextInputs,
  })  : additionalTextInputs = additionalTextInputs ?? [],
        selectedBasicIngredients = basicIngredients ?? {},
        selectedCuisines = cuisines ?? {},
        selectedDietaryRestrictions = dietaryRestrictions ?? {};

  PromptModel.empty()
      : images = [],
        additionalTextInputs = [],
        selectedBasicIngredients = {},
        selectedCuisines = {},
        selectedDietaryRestrictions = {},
        textInput = '';

  String get cuisines {
    return selectedCuisines.map((catFilter) => catFilter.name).join(',');
  }

  String get ingredients {
    return selectedBasicIngredients
        .map((ingredient) => ingredient.name)
        .join(', ');
  }

  String get dietaryRestrictions {
    return selectedDietaryRestrictions
        .map((restriction) => restriction.name)
        .join(', ');
  }

  List<XFile> images;
  String textInput;
  List<String> additionalTextInputs;
  Set<BasicIngredientsFilter> selectedBasicIngredients;
  Set<CuisineFilter> selectedCuisines;
  Set<DietaryRestrictionsFilter> selectedDietaryRestrictions;

  PromptModel copyWith({
    List<XFile>? images,
    String? textInput,
    List<String>? additionalTextInputs,
    Set<BasicIngredientsFilter>? basicIngredients,
    Set<CuisineFilter>? cuisineSelections,
    Set<DietaryRestrictionsFilter>? dietaryRestrictions,
  }) {
    return PromptModel(
      images: images ?? this.images,
      textInput: textInput ?? this.textInput,
      additionalTextInputs: additionalTextInputs ?? this.additionalTextInputs,
      basicIngredients: basicIngredients ?? selectedBasicIngredients,
      cuisines: cuisineSelections ?? selectedCuisines,
      dietaryRestrictions: dietaryRestrictions ?? selectedDietaryRestrictions,
    );
  }
}
