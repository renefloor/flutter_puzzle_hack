import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/theme/themes/themes.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class IslandTheme extends PuzzleTheme {
  /// {@macro simple_theme}
  const IslandTheme() : super();

  @override
  String get name => 'Islands';

  @override
  bool get hasTimer => false;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => PuzzleColors.water_light;

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
}

class IslandDarkTheme extends IslandTheme {
  /// {@macro simple_theme}
  const IslandDarkTheme() : super();

  @override
  Color get backgroundColor => PuzzleColors.water_dark;
}
