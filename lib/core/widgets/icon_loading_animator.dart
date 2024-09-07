import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';

class IconLoadingAnimator extends StatefulWidget {
  IconLoadingAnimator({
    required this.icons,
    super.key,
    this.animationDuration,
    this.millisecondsBetweenAnimations,
  });

  final List<IconData> icons;
  final Duration? animationDuration;
  final int? millisecondsBetweenAnimations;
  final List<Color> colors = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.tertiary,
    AppTheme.scrim,
    Colors.black87,
  ];

  @override
  State<IconLoadingAnimator> createState() => _IconLoadingAnimatorState();
}

Random rand = Random();

class _IconLoadingAnimatorState extends State<IconLoadingAnimator> {
  late IconData currentIcon;
  late Color currentColor;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    currentIcon = widget.icons[rand.nextInt(widget.icons.length)];
    currentColor = widget.colors[rand.nextInt(widget.colors.length)];

    timer = Timer.periodic(
      Duration(milliseconds: widget.millisecondsBetweenAnimations ?? 1000),
      (timer) {
        nextIcon();
      },
    );
  }

  void nextIcon() {
    setState(() {
      currentIcon = widget.icons[rand.nextInt(widget.icons.length)];
      currentColor = widget.colors[rand.nextInt(widget.colors.length)];
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: AppTheme.focusedBorderColor,
          width: 2,
        ),
      ),
      child: AnimatedSwitcher(
        duration: widget.animationDuration ?? const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          size: 75,
          color: currentColor,
          key: Key(currentIcon.hashCode.toString()),
          currentIcon,
        ),
      ),
    );
  }
}
