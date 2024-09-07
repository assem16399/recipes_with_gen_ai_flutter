import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  Widget bulletRow(String text, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon ?? Symbols.label_important_outline),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppTheme.defaultBorderRadius,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderColor),
        ),
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Use the form on this screen to ask '
              'Cat Chef to make a recipe for you.',
              style: AppTheme.heading3,
            ),
            const SizedBox(
              height: AppTheme.spacing4,
            ),
            bulletRow(
              'Add images of ingredients you have, '
              'like a picture of the inside of your fridge or pantry.',
              icon: Symbols.looks_one,
            ),
            const SizedBox(
              height: AppTheme.spacing7,
            ),
            bulletRow(
              "Choose what kind of food you're in the mood for, and what "
              'staple ingredients you have that might not be pictured.',
              icon: Symbols.looks_two,
            ),
            const SizedBox(
              height: AppTheme.spacing7,
            ),
            bulletRow(
              'In the text box at the bottom, add any additional context that '
              "you'd like. \nFor example, you could say \"I'm in a hurry!"
              " Make sure the recipe doesn't take longer "
              'than 30 minutes to make."',
              icon: Symbols.looks_3,
            ),
            const SizedBox(
              height: AppTheme.spacing7,
            ),
            bulletRow(
              'Submit the prompt, and Chef Noodle will give you a recipe!',
              icon: Symbols.looks_4,
            ),
            const SizedBox(
              height: AppTheme.spacing4,
            ),
            Text(
              'Steps 1, 2 and 3 are optional. More information will provide '
              'better results.',
              style: AppTheme.label,
            ),
            const SizedBox(height: AppTheme.spacing4),
            TextButton.icon(
              icon: const Icon(
                Symbols.close,
                color: Colors.black87,
              ),
              label: Text(
                'Close',
                style: AppTheme.dossierParagraph,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith(
                  (states) {
                    return const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppTheme.defaultBorderRadius),
                      ),
                    );
                  },
                ),
                textStyle: WidgetStateTextStyle.resolveWith(
                  (states) {
                    return AppTheme.dossierParagraph
                        .copyWith(color: Colors.black45);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
