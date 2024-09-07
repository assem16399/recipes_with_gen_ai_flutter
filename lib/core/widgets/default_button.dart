import 'package:flutter/material.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    required this.onPressed,
    required this.buttonText,
    required this.icon,
    super.key,
    this.iconRotateAngle,
    this.iconBackgroundColor,
    this.iconColor,
    this.buttonBackgroundColor,
    this.hoverColor,
  });

  final VoidCallback? onPressed;
  final String buttonText;
  final IconData icon;
  final double? iconRotateAngle;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? buttonBackgroundColor;
  final Color? hoverColor;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.iconBackgroundColor ?? Colors.transparent,
        ),
        child: Transform.rotate(
          angle: widget.iconRotateAngle ?? 0,
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? Colors.black87,
            size: 20,
          ),
        ),
      ),
      label: Text(
        widget.buttonText,
        style: AppTheme.dossierParagraph,
      ),
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return widget.hoverColor ?? AppTheme.secondary.withAlpha(77);
          }
          return widget.buttonBackgroundColor ??
              Theme.of(context).splashColor.withAlpha(77);
        }),
        shape: WidgetStateProperty.resolveWith((states) {
          return const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.all(
              Radius.circular(AppTheme.defaultBorderRadius),
            ),
          );
        }),
        textStyle: WidgetStateTextStyle.resolveWith(
          (states) {
            return AppTheme.dossierParagraph.copyWith(
              color: Colors.black45,
            );
          },
        ),
      ),
    );
  }
}
