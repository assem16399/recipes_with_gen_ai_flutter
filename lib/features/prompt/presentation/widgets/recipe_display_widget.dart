import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/recipe_model.dart';

class RecipeDisplayWidget extends StatelessWidget {
  const RecipeDisplayWidget({
    required this.recipe,
    super.key,
    this.subheading,
  });

  final Recipe recipe;
  final Widget? subheading;

  List<Widget> _buildIngredients(List<String> ingredients) {
    final widgets = <Widget>[];
    for (final ingredient in ingredients) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.stat_0_rounded,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                ingredient,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildInstructions(List<String> instructions) {
    final widgets = <Widget>[];

    // check for existing numbers in instructions.
    if (instructions.first.startsWith(RegExp('[0-9]'))) {
      for (final instruction in instructions) {
        widgets
          ..add(Text(instruction))
          ..add(const SizedBox(height: AppTheme.spacing6));
      }
    } else {
      for (var i = 0; i < instructions.length; i++) {
        widgets
          ..add(
            Text(
              '${i + 1}. ${instructions[i]}',
              softWrap: true,
            ),
          )
          ..add(const SizedBox(height: AppTheme.spacing6));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.defaultBorderRadius),
            color: AppTheme.primary.withAlpha(128),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            softWrap: true,
                            style: AppTheme.heading2,
                          ),
                          if (subheading != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.spacing7,
                              ),
                              child: subheading,
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return AppTheme.scrim.withAlpha(153);
                          }
                          return Colors.white;
                        }),
                        shape: WidgetStateProperty.resolveWith(
                          (states) {
                            return RoundedRectangleBorder(
                              side: const BorderSide(
                                color: AppTheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.defaultBorderRadius,
                              ),
                            );
                          },
                        ),
                        textStyle: WidgetStateTextStyle.resolveWith(
                          (states) {
                            return AppTheme.dossierParagraph.copyWith(
                              color: Colors.black45,
                            );
                          },
                        ),
                      ),
                      onPressed: () async {
                        await showDialog<dynamic>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacing7,
                                ),
                                child: Text(recipe.description),
                              ),
                            );
                          },
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacing6,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: SvgPicture.asset(
                                  'assets/chef_cat.svg',
                                  semanticsLabel: 'Chef cat icon',
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(1, -6),
                                child: Transform.rotate(
                                  angle: -pi / 20.0,
                                  child: Text(
                                    'Chef Noodle \n says...',
                                    style: AppTheme.label,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 40,
                  color: Colors.black26,
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Allergens:',
                          style: AppTheme.paragraph.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(recipe.allergens.join(', ')),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Servings:',
                          style: AppTheme.paragraph.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(recipe.servings),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Nutrition per serving:',
                          style: AppTheme.paragraph.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(''),
                      ],
                    ),
                    ...recipe.nutritionInformation.entries.map((entry) {
                      return TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Symbols.stat_0_rounded,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: AppTheme.label,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            entry.value as String,
                            style: AppTheme.label,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          /// Body section
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing7,
                  ),
                  child: Text('Ingredients:', style: AppTheme.subheading1),
                ),
                ..._buildIngredients(recipe.ingredients),
                const SizedBox(height: AppTheme.spacing4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing7,
                  ),
                  child: Text(
                    'Instructions:',
                    style: AppTheme.subheading1,
                  ),
                ),
                ..._buildInstructions(recipe.instructions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
