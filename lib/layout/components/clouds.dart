import 'package:flutter/material.dart';
import 'dart:math';

import '../responsive_layout_builder.dart';

class Clouds extends StatefulWidget {
  const Clouds({
    Key? key,
    required this.start,
    required this.relativeDistance,
  }) : super(key: key);

  /// Start is between 0 and 1, with 0 entering the screen and 1 leaving the screen.
  final double start;

  /// Distance is between 0 and 1, with 0 being closest
  final double relativeDistance;

  @override
  _CloudsState createState() => _CloudsState();
}

class _CloudsState extends State<Clouds> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  late double _cloudPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: (300 * (1 + widget.relativeDistance*3)).floor(),
      ),
    );
    _controller.value = widget.start;
    _cloudPosition = widget.start;
    positionAnimation =
        Tween<double>(begin: 1.5, end: -1.5).animate(_controller)
          ..addListener(() {
            setState(() {
              _cloudPosition = positionAnimation.value;
            });
          });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      defaultBuilder: (_, child) => Container(
        margin: EdgeInsets.only(top: 100 + 100 * widget.relativeDistance),
        height: 50 * (1 - widget.relativeDistance),
        alignment: Alignment.centerRight,
        child: child,
      ),
      smallWide: (_, child) => Container(
        margin: EdgeInsets.only(top: 50 + 50 * widget.relativeDistance),
        height: 25 * (1 - widget.relativeDistance),
        alignment: Alignment.centerRight,
        child: child,
      ),
      child: (_) => Align(
        alignment: Alignment(_cloudPosition, 0),
        child: Image.asset(
          'assets/images/clouds.png',
        ),
      ),
    );
  }
}
