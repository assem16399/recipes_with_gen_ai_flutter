import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/utils/enums.dart';
import 'package:recipes_with_gen_ai/core/utils/extensions.dart';
import 'package:recipes_with_gen_ai/core/widgets/default_button.dart';
import 'package:recipes_with_gen_ai/core/widgets/filter_chip_selection.dart';
import 'package:recipes_with_gen_ai/core/widgets/highlighted_border_on_hover_widget.dart';
import 'package:recipes_with_gen_ai/features/prompt/logic/prompt_cubit.dart';
import 'package:recipes_with_gen_ai/features/prompt/presentation/widgets/full_prompt_dialog.dart';
import 'package:recipes_with_gen_ai/features/prompt/presentation/widgets/image_input_widget.dart';
import 'package:recipes_with_gen_ai/features/prompt/presentation/widgets/recipe_dialog_screen.dart';

const double kAvatarSize = 50;
const double collapsedHeight = 100;
const double expandedHeight = 300;
const double elementPadding = AppTheme.spacing7;

class PromptScreen extends StatelessWidget {
  const PromptScreen({required this.canScroll, super.key});

  final bool canScroll;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: canScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Container(
            padding: constraints.isMobile
                ? const EdgeInsets.all(AppTheme.spacing7)
                : const EdgeInsets.only(
                    left: AppTheme.spacing7,
                    right: AppTheme.spacing7,
                    bottom: AppTheme.spacing1,
                    top: AppTheme.spacing7,
                  ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.borderColor),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(AppTheme.defaultBorderRadius),
                  bottomLeft: Radius.circular(AppTheme.defaultBorderRadius),
                ),
              ),
              child: BlocConsumer<PromptCubit, PromptState>(
                listener: (context, state) {
                  if (state is PromptError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is PromptLoaded) {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => RecipeDialogScreen(
                        recipe: state.recipe,
                        actions: [
                          DefaultButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            buttonText: 'Save Recipe',
                            icon: Symbols.save,
                          ),
                        ],
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<PromptCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(elementPadding + 10),
                        child: Text(
                          'Create a recipe:',
                          style: AppTheme.dossierParagraph.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          elementPadding,
                        ),
                        child: SizedBox(
                          height: constraints.isMobile ? 130 : 230,
                          child: AddImageToPromptWidget(
                            height: constraints.isMobile ? 100 : 200,
                            width: constraints.isMobile ? 100 : 200,
                          ),
                        ),
                      ),
                      if (constraints.isMobile)
                        Padding(
                          padding: const EdgeInsets.all(elementPadding),
                          child: _FilterChipSection(
                            label: 'I also have these staple ingredients: ',
                            child: FilterChipSelectionInput<
                                BasicIngredientsFilter>(
                              onChipSelected: cubit.addBasicIngredients,
                              allValues: BasicIngredientsFilter.values,
                              selectedValues:
                                  state.promptModel.selectedBasicIngredients,
                            ),
                          ),
                        ),
                      if (constraints.isMobile)
                        Padding(
                          padding: const EdgeInsets.all(elementPadding),
                          child: _FilterChipSection(
                            label: "I'm in the mood for: ",
                            child: FilterChipSelectionInput<CuisineFilter>(
                              onChipSelected: cubit.addCategoryFilters,
                              allValues: CuisineFilter.values,
                              selectedValues:
                                  state.promptModel.selectedCuisines,
                            ),
                          ),
                        ),
                      if (constraints.isMobile)
                        Padding(
                          padding: const EdgeInsets.all(elementPadding),
                          child: _FilterChipSection(
                            label: 'I have the following dietary restrictions:',
                            child: FilterChipSelectionInput<
                                DietaryRestrictionsFilter>(
                              onChipSelected: cubit.addDietaryRestrictionFilter,
                              allValues: DietaryRestrictionsFilter.values,
                              selectedValues:
                                  state.promptModel.selectedDietaryRestrictions,
                            ),
                          ),
                        ),
                      if (!constraints.isMobile)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(elementPadding),
                                child: _FilterChipSection(
                                  label: "I'm in the mood for: ",
                                  child:
                                      FilterChipSelectionInput<CuisineFilter>(
                                    onChipSelected: cubit.addCategoryFilters,
                                    allValues: CuisineFilter.values,
                                    selectedValues:
                                        state.promptModel.selectedCuisines,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(elementPadding),
                                child: _FilterChipSection(
                                  label:
                                      'I also have these staple ingredients: ',
                                  child: FilterChipSelectionInput<
                                      BasicIngredientsFilter>(
                                    onChipSelected: cubit.addBasicIngredients,
                                    allValues: BasicIngredientsFilter.values,
                                    selectedValues: state
                                        .promptModel.selectedBasicIngredients,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(elementPadding),
                                child: _FilterChipSection(
                                  label:
                                      'I have the following dietary restrictions:',
                                  child: FilterChipSelectionInput<
                                      DietaryRestrictionsFilter>(
                                    onChipSelected:
                                        cubit.addDietaryRestrictionFilter,
                                    allValues: DietaryRestrictionsFilter.values,
                                    selectedValues: state.promptModel
                                        .selectedDietaryRestrictions,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(elementPadding),
                        child: _TextField(
                          controller: cubit.promptTextController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (!constraints.isMobile) const Spacer(),
                            if (!constraints.isMobile)
                              Expanded(
                                flex: 3,
                                child: DefaultButton(
                                  onPressed: cubit.resetPrompt,
                                  buttonText: 'Reset prompt',
                                  icon: Symbols.restart_alt,
                                  iconColor: Colors.black45,
                                  buttonBackgroundColor: Colors.transparent,
                                  hoverColor: AppTheme.secondary.withAlpha(25),
                                ),
                              ),
                            const Spacer(),
                            Expanded(
                              flex: constraints.isMobile ? 10 : 3,
                              child: DefaultButton(
                                onPressed: () {
                                  final prompt = cubit.buildPrompt();
                                  showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return FullPromptDialog(
                                        promptModel: prompt,
                                      );
                                    },
                                  );
                                },
                                buttonText: 'Full prompt',
                                icon: Symbols.info_rounded,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: constraints.isMobile ? 10 : 3,
                              child: DefaultButton(
                                onPressed: cubit.submitPrompt,
                                buttonText: 'Submit prompt',
                                icon: Symbols.send,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      if (constraints.isMobile)
                        Align(
                          child: DefaultButton(
                            onPressed: cubit.resetPrompt,
                            buttonText: 'Reset prompt',
                            icon: Symbols.restart_alt,
                            iconColor: Colors.black45,
                            buttonBackgroundColor: Colors.transparent,
                            hoverColor: AppTheme.secondary.withAlpha(25),
                          ),
                        ),
                      const SizedBox(height: 200),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterChipSection extends StatelessWidget {
  const _FilterChipSection({
    required this.child,
    required this.label,
  });

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return HighlightBorderOnHoverWidget(
      borderRadius: BorderRadius.zero,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor.withAlpha(25),
          border: Border.all(
            color: AppTheme.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing7),
              child: Text(
                label,
                style: AppTheme.dossierParagraph,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollPadding: const EdgeInsets.only(bottom: 150),
      maxLines: null,
      minLines: 3,
      controller: controller,
      style: WidgetStateTextStyle.resolveWith(
        (states) => AppTheme.dossierParagraph,
      ),
      decoration: InputDecoration(
        fillColor: Theme.of(context).splashColor,
        hintText: 'Add additional context...',
        hintStyle: WidgetStateTextStyle.resolveWith(
          (states) => AppTheme.dossierParagraph,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black45),
        ),
        filled: true,
      ),
    );
  }
}
