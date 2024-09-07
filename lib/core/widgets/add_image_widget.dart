import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';

class AddImage extends StatefulWidget {
  const AddImage({
    required this.onTap,
    super.key,
    this.height = 100,
    this.width = 100,
  });

  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool hovered = false;
  bool tappedDown = false;

  Color get buttonColor {
    final state = (hovered, tappedDown);
    return switch (state) {
      // tapped down state
      (_, true) => AppTheme.secondary.withAlpha(179),
      // hovered
      (true, _) => AppTheme.secondary.withAlpha(77),
      // base color
      (_, _) => AppTheme.secondary.withAlpha(77),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            tappedDown = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            tappedDown = false;
          });
          widget.onTap();
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: buttonColor,
              ),
              child: const Center(
                child: Icon(
                  Symbols.add_photo_alternate_rounded,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
