import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaperPlane extends StatefulWidget {
  const PaperPlane({Key? key}) : super(key: key);

  @override
  _PaperPlaneState createState() => _PaperPlaneState();
}

class _PaperPlaneState extends State<PaperPlane>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
          _animation =
              CurveTween(curve: Curves.easeOutBack).animate(_controller);
        }
        if (status == AnimationStatus.dismissed) {
          _animation =
              CurveTween(curve: Curves.easeOutCubic).animate(_controller);
        }
      })
      ..addListener(() => setState(() {}));
    _animation = CurveTween(curve: Curves.easeOutCubic).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1 / 3,
        child: Column(
          children: [
            Expanded(
              flex: 0 + (_animation.value * 1000).floor(),
              child: const SizedBox.shrink(),
            ),
            GestureDetector(
              onTap: () => _controller.forward(),
              child: Transform.rotate(
                angle: _getAngle(),
                child: Image.asset('assets/images/paper_plane.png'),
              ),
            ),
            Expanded(
              flex: 1000 - (_animation.value * 1000).ceil(),
              child: const SizedBox.shrink(),
            ),
            Image.asset('assets/images/paper_plane_shadow.png'),
          ],
        ),
      ),
    );
  }

  double _getAngle() {
    if (!_controller.isAnimating) return 0;
    if (_controller.status == AnimationStatus.forward) {
      if (_animation.value < 0.5) {
        return 0.5;
        return _animation.value;
      }
      return (_animation.value - 1) * -1;
    }
    if (_animation.value < 0.5) {
      return -_animation.value;
    }
    return _animation.value - 1;
  }
}
