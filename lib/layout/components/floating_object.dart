import 'dart:math';

import 'package:flutter/material.dart';

class FloatingDirection {
  FloatingDirection._(
    this._anchor,
    this._horizontalDirection,
    this._verticalDirection,
  );

  factory FloatingDirection.se() {
    return FloatingDirection._(const Point(1, 1), -2, 1);
  }

  factory FloatingDirection.sw() {
    return FloatingDirection._(const Point(-1, 1), -2, -1);
  }

  factory FloatingDirection.nw() {
    return FloatingDirection._(const Point(-1, -1), 2, -1);
  }

  factory FloatingDirection.ne() {
    return FloatingDirection._(const Point(1, -1), 2, 1);
  }

  final double _verticalDirection;
  final double _horizontalDirection;
  final Point _anchor;
}

class FloatingObject extends StatefulWidget {
  const FloatingObject({
    required this.direction,
    this.distance = 1,
    required this.puzzleSize,
    required this.screenSize,
    required this.child,
    required this.childSize,
    required this.bottomPadding,
    Key? key,
  }) : super(key: key);
  final FloatingDirection direction;
  final double distance;
  final Size puzzleSize;
  final Size screenSize;
  final Widget child;
  final double childSize;
  final double bottomPadding;

  @override
  _FloatingObjectState createState() => _FloatingObjectState();
}

class _FloatingObjectState extends State<FloatingObject>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _verticalAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );
    _controller.addListener(() => setState(() {}));
    _calculateAnimation();
    _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant FloatingObject oldWidget) {
    if (oldWidget.child != widget.child ||
        oldWidget.direction != widget.direction ||
        oldWidget.screenSize != widget.screenSize ||
        oldWidget.puzzleSize != widget.puzzleSize) {
      _calculateAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _calculateAnimation() {
    final anchor = _calculateAnchor();
    final start = _calculateStart(anchor: anchor);
    final end = _calculateEnd(anchor: anchor);
    _horizontalAnimation =
        Tween(begin: start.x, end: end.x).animate(_controller);
    _verticalAnimation = Tween(begin: start.y, end: end.y).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _verticalAnimation.value,
      left: _horizontalAnimation.value,
      child: SizedBox.square(
        dimension: widget.childSize,
        child: widget.child,
      ),
    );
  }

  Point<double> _calculateAnchor() {
    final center = Point(
      widget.screenSize.width / 2,
      (widget.screenSize.height - widget.bottomPadding) / 2,
    );
    final x = center.x +
        widget.puzzleSize.width /
            2 *
            widget.direction._anchor.x *
            widget.distance -
        widget.childSize / 2;
    final y = center.y +
        widget.puzzleSize.height /
            2 *
            widget.direction._anchor.y *
            widget.distance -
        widget.childSize / 2;
    return Point(x, y);
  }

  Point<double> _calculateStart({required Point<double> anchor}) {
    var start = anchor;
    final direction = Point(
      widget.direction._horizontalDirection,
      widget.direction._verticalDirection,
    );
    while (isWithin(widget.screenSize, start)) {
      start = start - direction;
    }
    return start;
  }

  Point<double> _calculateEnd({required Point<double> anchor}) {
    var end = anchor;
    final direction = Point(
      widget.direction._horizontalDirection,
      widget.direction._verticalDirection,
    );
    while (isWithin(widget.screenSize, end)) {
      end = end + direction;
    }
    return end;
  }

  bool isWithin(Size size, Point point) {
    if (point.y < -widget.childSize) return false;
    if (point.x < -widget.childSize) return false;
    if (point.y > size.height + widget.childSize) return false;
    if (point.x > size.width + widget.childSize) return false;
    return true;
  }
}
