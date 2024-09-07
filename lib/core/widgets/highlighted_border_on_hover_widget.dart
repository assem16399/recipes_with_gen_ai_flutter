import 'package:flutter/material.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';

class HighlightBorderOnHoverWidget extends StatefulWidget {
  const HighlightBorderOnHoverWidget({
    required this.child,
    required this.borderRadius,
    super.key,
    this.color = AppTheme.secondary,
  });

  final Widget child;
  final Color color;
  final BorderRadius borderRadius;

  @override
  State<HighlightBorderOnHoverWidget> createState() =>
      _HighlightBorderOnHoverWidgetState();
}

class _HighlightBorderOnHoverWidgetState
    extends State<HighlightBorderOnHoverWidget> {
  bool hovered = false;

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
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor.withAlpha(25),
          border: Border.all(
            color: hovered ? widget.color : AppTheme.borderColor,
          ),
          borderRadius: widget.borderRadius,
        ),
        child: widget.child,
      ),
    );
  }
}
