import 'package:flutter/material.dart';
import 'dart:math';

import '../responsive_layout_builder.dart';

class Clouds extends StatefulWidget {
  const Clouds({
    Key? key,
    required this.durationInSeconds,
    required this.start,
    required this.relativeHeight,
  }) : super(key: key);

  /// Duration in seconds from entering the screen to leaving the screen.
  final int durationInSeconds;

  /// Start is between 0 and 1, with 0 entering the screen and 1 leaving the screen.
  final double start;

  /// Height is between 0 and 1, with 0 being lowest
  final double relativeHeight;

  @override
  _CloudsState createState() => _CloudsState();
}

class _CloudsState extends State<Clouds> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  late double _cloudPosition;
  late double _opacity = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );
    _controller.value = widget.start;
    _cloudPosition = widget.start;
    positionAnimation =
        Tween<double>(begin: 0, end: 0.8).animate(_controller)
          ..addListener(() {
            setState(() {
              _cloudPosition = positionAnimation.value;
            });
          });
    opacityAnimation = Tween<double>(begin: 2, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _opacity = max(0, min(1, opacityAnimation.value));
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
      large: (_, __) => _alignCloud(),
      medium: (_, __) => _alignCloud(
        widthFactor: 1.5,
      ),
      small: (_, __) => _alignCloud(
        widthFactor: 2,
      ),
      xLarge: (_, __) => _alignCloud(widthFactor: 0.8),
    );
  }

  Widget _alignCloud({
    double heightFactor = 1,
    double widthFactor = 1,
  }) {

    final y = (1 - _cloudPosition) *
        0.6 *
        heightFactor *
        (1 - widget.relativeHeight);
    final x = _cloudPosition * 0.8 * widthFactor * (1 - widget.relativeHeight);

    return Align(
      alignment: FractionalOffset(x, y),
      child: Transform.translate(
        offset: const Offset(-260,0),
        child: Opacity(
            opacity: _opacity, child: Image.asset('assets/images/clouds.png')),
      ),
    );
  }
}
