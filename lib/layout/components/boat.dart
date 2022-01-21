import 'package:flutter/material.dart';

import '../responsive_layout_builder.dart';

class Boat extends StatelessWidget {
  const Boat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => _SizedBoat(size: 1, offSet: 1.3),
      medium: (_, __) => _SizedBoat(size: 1.2, offSet: 1.4),
      large: (_, __) => _SizedBoat(
        size: 2,
        offSet: 2,
      ),
      xLarge: (_, __) => _SizedBoat(
        size: 2,
        offSet: 1.4,
      ),
    );
  }
}

class _SizedBoat extends StatelessWidget {
  const _SizedBoat({
    required this.size,
    required this.offSet,
    Key? key,
  }) : super(key: key);
  final double size;
  final double offSet;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(offSet, offSet * 0.8),
      child: SizedBox(
        width: size * 150,
        child: Image.asset('assets/images/boat.png'),
      ),
    );
  }
}
