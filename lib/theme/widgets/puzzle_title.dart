import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:island_slide_puzzle/colors/colors.dart';
import 'package:island_slide_puzzle/theme/bloc/theme_bloc.dart';
import 'package:island_slide_puzzle/theme/theme.dart';
import 'package:island_slide_puzzle/typography/typography.dart';

/// {@template puzzle_title}
/// Displays the title of the puzzle in the given color.
/// {@endtemplate}
class PuzzleTitle extends StatelessWidget {
  /// {@macro puzzle_title}
  const PuzzleTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  /// The title to be displayed.
  final String title;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        context.select((ThemeBloc bloc) => bloc.state.theme).titleStyle;
    return SizedBox(
      width: 290,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}
