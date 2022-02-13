import 'package:flutter/material.dart';

class Waves extends StatelessWidget {
  const Waves({required this.top, this.left, this.right, Key? key}) : super(key: key);
  final double? left;
  final double? right;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      width: 100,
      child: Image.asset('assets/images/wave.png'),
    );
  }
}
