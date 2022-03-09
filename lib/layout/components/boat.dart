import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

const _animationName = 'Puzzleboat';

class Boat extends StatelessWidget {
  const Boat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/images/boat-waves.riv',
      animations: [_animationName],
    );
  }
}
