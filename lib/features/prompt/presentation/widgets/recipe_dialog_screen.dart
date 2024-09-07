import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/widgets/default_button.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/recipe_model.dart';
import 'package:recipes_with_gen_ai/features/prompt/presentation/widgets/recipe_display_widget.dart';

class RecipeDialogScreen extends StatelessWidget {
  const RecipeDialogScreen({
    required this.recipe,
    required this.actions,
    super.key,
    this.subheading,
  });

  final Recipe recipe;
  final List<Widget> actions;
  final Widget? subheading;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: RecipeDisplayWidget(
              recipe: recipe,
              subheading: subheading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  buttonText: 'Close',
                  icon: Symbols.close,
                ),
                ...actions,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
