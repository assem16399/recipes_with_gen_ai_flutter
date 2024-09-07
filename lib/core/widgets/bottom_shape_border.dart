import 'package:flutter/material.dart';

class BottomBarShapeBorder extends ShapeBorder {
  const BottomBarShapeBorder(this.radius);

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
      ..moveTo(rect.left, rect.top - radius)
      ..quadraticBezierTo(
        rect.left,
        rect.top,
        rect.left + radius,
        rect.top,
      )
      ..lineTo(rect.right - radius, rect.top)
      ..quadraticBezierTo(
        rect.right,
        rect.top,
        rect.right,
        rect.bottom,
      )
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top + radius)
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
