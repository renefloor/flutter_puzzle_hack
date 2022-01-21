import 'package:flutter/material.dart';

import '../responsive_layout_builder.dart';

class Iceberg extends StatelessWidget {
  const Iceberg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: -50,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
            width: 100, child: Image.asset('assets/images/iceberg.png')),
        medium: (_, __) => SizedBox(
            width: 150, child: Image.asset('assets/images/iceberg.png')),
        large: (_, __) => SizedBox(
            width: 200, child: Image.asset('assets/images/iceberg.png')),
        xLarge: (_, __) => SizedBox(
            width: 250, child: Image.asset('assets/images/iceberg.png')),
      ),
    );
  }
}
