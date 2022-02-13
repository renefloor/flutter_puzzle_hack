import 'package:flutter/material.dart';

typedef IslandHeightAnimatorBuilder = Widget Function(double relativeDepth);
class IslandHeightAnimator extends StatelessWidget {
  const IslandHeightAnimator({
    required this.isShuffling,
    this.isHovered = false,
    this.isTapped = false,
    required this.builder,
    Key? key,
  }) : super(key: key);
  final bool isShuffling;
  final bool isHovered;
  final bool isTapped;
  final IslandHeightAnimatorBuilder builder;

  @override
  Widget build(BuildContext context) {
    var position = 0.0;
    if (isTapped) {
      position += 0.05;
    } else if (isHovered) {
      position += 0.02;
    }
    if (isShuffling) position += 0.8;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: position),
      curve: isTapped || isHovered ? Curves.linear : Curves.easeOutBack,
      duration: Duration(
        milliseconds: isTapped || isHovered
            ? 50
            : isShuffling
                ? 5000
                : 500,
      ),
      builder: (_, value, __) => builder(value),
    );
  }
}
