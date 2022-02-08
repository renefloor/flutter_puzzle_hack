import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template puzzle_title}
/// Displays the title of the puzzle in the given color.
/// {@endtemplate}
class PuzzleTitle extends StatelessWidget {
  /// {@macro puzzle_title}
  const PuzzleTitle({
    Key? key,
    required this.title,
    this.color = PuzzleColors.primary1,
  }) : super(key: key);

  /// The title to be displayed.
  final String title;

  /// The color of the [title], defaults to [PuzzleColors.primary1].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Text(
        title,
        style: PuzzleTextStyle.title.copyWith(
          color: color,
          fontSize: 54,
          height: 1,
        ),
      ),
    );
  }
}
