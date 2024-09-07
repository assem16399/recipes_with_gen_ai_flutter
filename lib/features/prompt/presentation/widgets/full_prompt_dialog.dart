import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/widgets/prompt_image_widget.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/prompt_model.dart';

class FullPromptDialog extends StatelessWidget {
  const FullPromptDialog({required this.promptModel, super.key});

  final PromptModel promptModel;

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
    return Dialog.fullscreen(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
          ),
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "This is the full prompt that will be sent to Google's "
                'Gemini model.',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: AppTheme.spacing4),
              if (promptModel.images.isNotEmpty)
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppTheme.borderColor,
                      ),
                    ),
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final image in promptModel.images)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: PromptImage(
                            file: image,
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.spacing4),
              bulletRow(promptModel.textInput),
              if (promptModel.additionalTextInputs.isNotEmpty)
                ...promptModel.additionalTextInputs.map(bulletRow),
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
      ),
    );
  }
}
