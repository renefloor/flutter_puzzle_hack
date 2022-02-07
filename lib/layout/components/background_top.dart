import 'package:flutter/material.dart';

import '../responsive_layout_builder.dart';

class BackgroundTop extends StatelessWidget {
  const BackgroundTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topImage =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? 'assets/images/background_top_light.png'
            : 'assets/images/background_top_dark.png';

    return ResponsiveLayoutBuilder(
      large: (_, __) => Image.asset(
        topImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      medium: (_, __) => Image.asset(
        topImage,
        height: 200,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      small: (_, __) => Image.asset(
        topImage,
        height: 200,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      smallWide: (_, __) => Image.asset(
        topImage,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
