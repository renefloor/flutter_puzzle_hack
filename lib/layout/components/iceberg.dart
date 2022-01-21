import 'package:flutter/material.dart';

class Iceberg extends StatelessWidget {
  const Iceberg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -50,
      child: Align(
        alignment: const FractionalOffset(0.8, 0),
        child: Image.asset('assets/images/iceberg.png'),
      ),
    );
  }
}
