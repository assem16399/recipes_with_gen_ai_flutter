import 'package:flutter/material.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/utils/enums.dart';
import 'package:recipes_with_gen_ai/core/utils/extensions.dart';

class FilterChipSelectionInput<T> extends StatefulWidget {
  const FilterChipSelectionInput({
    required this.onChipSelected,
    required this.selectedValues,
    required this.allValues,
    super.key,
  });

  final void Function(Set<T>) onChipSelected;
  final Set<T> selectedValues;
  final List<T> allValues;

  @override
  State<FilterChipSelectionInput<T>> createState() =>
      _CategorySelectionInputState<T>();
}

class _CategorySelectionInputState<T>
    extends State<FilterChipSelectionInput<T>> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: Wrap(
            spacing: 5,
            runSpacing: constraints.isMobile ? 5.0 : -5.0,
            children: List<Widget>.generate(
              widget.allValues.length,
              (idx) {
                final chipData = widget.allValues[idx];
                String label(dynamic chipData) {
                  if (chipData is CuisineFilter) {
                    return cuisineReadable(chipData);
                  } else if (chipData is DietaryRestrictionsFilter) {
                    return dietaryRestrictionReadable(chipData);
                  } else if (chipData is BasicIngredientsFilter) {
                    return chipData.name;
                  } else {
                    throw Exception('unknown enum');
                  }
                }

                return FilterChip(
                  color: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return AppTheme.secondary.withAlpha(128);
                    }
                    if (states.contains(WidgetState.selected)) {
                      return AppTheme.secondary.withAlpha(77);
                    }
                    return Theme.of(context).splashColor;
                  }),
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(4),
                  label: Text(
                    label(chipData),
                    style: AppTheme.dossierParagraph,
                  ),
                  selected: widget.selectedValues.contains(chipData),
                  onSelected: (selected) {
                    setState(
                      () {
                        if (selected) {
                          widget.selectedValues.add(chipData);
                        } else {
                          widget.selectedValues.remove(chipData);
                        }
                        widget.onChipSelected(widget.selectedValues);
                      },
                    );
                  },
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
