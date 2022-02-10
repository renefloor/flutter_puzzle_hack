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

class FloatingObjectFactory {
  const FloatingObjectFactory({
    this.distance = 1,
    required this.puzzleSize,
    required this.screenSize,
    required this.childSize,
    required this.bottomPadding,
  });

  final double distance;
  final Size puzzleSize;
  final Size screenSize;
  final double childSize;
  final double bottomPadding;

  FloatingObject _create({
    required Widget child,
    required FloatingDirection direction,
    required double speed,
  }) {
    return FloatingObject(
      direction: direction,
      puzzleSize: puzzleSize,
      screenSize: screenSize,
      childSize: childSize,
      bottomPadding: bottomPadding,
      speed: speed,
      child: child,
    );
  }

  FloatingObject nw(Widget child, {double speed = 1}) {
    return _create(
      child: child,
      direction: FloatingDirection.nw(),
      speed: speed,
    );
  }

  FloatingObject ne(Widget child, {double speed = 1}) {
    return _create(
      child: child,
      direction: FloatingDirection.ne(),
      speed: speed,
    );
  }

  FloatingObject se(Widget child, {double speed = 1}) {
    return _create(
      child: child,
      direction: FloatingDirection.se(),
      speed: speed,
    );
  }

  FloatingObject sw(Widget child, {double speed = 1}) {
    return _create(
      child: child,
      direction: FloatingDirection.sw(),
      speed: speed,
    );
  }
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
    required this.speed,
    Key? key,
  }) : super(key: key);
  final FloatingDirection direction;
  final double distance;
  final Size puzzleSize;
  final Size screenSize;
  final Widget child;
  final double childSize;
  final double bottomPadding;
  final double speed;

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
      duration: Duration(seconds: (80 / widget.speed).floor()),
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
    final topArea = widget.screenSize.height / 3;
    final height = _verticalAnimation.value + widget.childSize * 0.90;
    final scale = Curves.easeOutCubic.transform(
      (height / topArea).clamp(0.0, 1.0),
    );

    return Positioned(
      top: _verticalAnimation.value,
      left: _horizontalAnimation.value,
      child: Container(
        height: widget.childSize,
        width: widget.childSize,
        alignment: Alignment.bottomCenter,
        child: SizedBox.square(
          dimension: widget.childSize * scale,
          child: widget.child,
        ),
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
