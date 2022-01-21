import 'package:flutter/material.dart';

import '../responsive_layout_builder.dart';

const _topImage = 'assets/images/background_top.png';

class BackgroundTop extends StatelessWidget {
  const BackgroundTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      large: (_, __) => Image.asset(
        _topImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      medium: (_, __) => Image.asset(
        _topImage,
        height: 200,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      small: (_, __) => Image.asset(
        _topImage,
        height: 200,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      smallWide: (_, __) => Image.asset(
        _topImage,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
