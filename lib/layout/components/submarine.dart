import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

const _animationName = 'Animation 1';

class Submarine extends StatelessWidget {
  const Submarine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/images/submarine.riv',
      animations: [_animationName],
    );
  }
}
