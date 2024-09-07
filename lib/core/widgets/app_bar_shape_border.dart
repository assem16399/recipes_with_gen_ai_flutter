import 'package:flutter/material.dart';

class AppBarShapeBorder extends ShapeBorder {
  const AppBarShapeBorder(this.radius);

  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path(); // Define inner path if needed
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Define your custom shape path here
    final path = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left, rect.bottom - (radius * 2))
      ..quadraticBezierTo(
        rect.left,
        rect.bottom - radius,
        rect.left + radius,
        rect.bottom - radius,
      )
      ..lineTo(rect.right - radius, rect.bottom - radius)
      ..quadraticBezierTo(
        rect.right,
        rect.bottom - radius,
        rect.right,
        rect.bottom,
      )
      ..lineTo(rect.right, rect.top)
      ..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Define your painting logic here
    final paint = Paint()..color = Colors.transparent;
    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) {
    // Implement scaling if needed
    return this;
  }
}
