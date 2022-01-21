import 'package:flutter/material.dart';

class Boat extends StatelessWidget {
  const Boat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -100,
      right: -100,
      child: Image.asset('assets/images/boat.png'),
    );
  }
}
