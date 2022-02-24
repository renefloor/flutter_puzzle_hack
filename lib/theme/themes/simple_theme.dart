import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:island_slide_puzzle/colors/colors.dart';
import 'package:island_slide_puzzle/layout/layout.dart';
import 'package:island_slide_puzzle/theme/themes/themes.dart';

import '../../typography/text_styles.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class IslandTheme extends PuzzleTheme {
  /// {@macro simple_theme}
  const IslandTheme() : super();

  @override
  String get name => 'Island';

  @override
  bool get hasTimer => false;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => PuzzleColors.water_light;

  Color get backgroundColorSecondary => PuzzleColors.water_light_secondary;

  @override
  Color get defaultColor => Colors.indigo;

  @override
  Color get hoverColor => PuzzleColors.primary3;

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const SimplePuzzleLayoutDelegate();

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        hasCountdown,
        backgroundColor,
        defaultColor,
        hoverColor,
        pressedColor,
        layoutDelegate,
      ];

  TextStyle get nameStyle => PuzzleTextStyle.name;
  TextStyle get titleStyle => PuzzleTextStyle.title;
}

class IslandDarkTheme extends IslandTheme {
  /// {@macro simple_theme}
  const IslandDarkTheme() : super();

  @override
  Color get backgroundColor => PuzzleColors.water_dark;

  @override
  Color get backgroundColorSecondary => PuzzleColors.water_dark_secondary;

  @override
  TextStyle get titleStyle => PuzzleTextStyle.title.copyWith(
        color: PuzzleColors.primary0,
      );
}
