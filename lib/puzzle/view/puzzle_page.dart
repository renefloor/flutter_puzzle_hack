import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:island_slide_puzzle/audio/audio_control_bloc.dart';
import 'package:island_slide_puzzle/layout/components/puzzle_keyboard_handler.dart';
import 'package:island_slide_puzzle/layout/layout.dart';
import 'package:island_slide_puzzle/models/models.dart';
import 'package:island_slide_puzzle/puzzle/puzzle.dart';
import 'package:island_slide_puzzle/theme/theme.dart';
import 'package:island_slide_puzzle/timer/timer.dart';

import '../../audio/audio_control_listener.dart';
import '../../layout/components/island_puzzle_tile.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final themeBloc = ThemeBloc(
      themes: [
        if (isDarkMode) const IslandDarkTheme() else const IslandTheme(),
      ],
    );
    return BlocProvider.value(
      value: themeBloc,
      child: const PuzzleView(),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = false;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.4],
            colors: [
              theme.backgroundColorSecondary,
              theme.backgroundColor,
            ],
          ),
        ),
        child: BlocProvider(
            create: (context) => AudioControlBloc(
                  repository: AudioStateRepository(),
                ),
            child: BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
              child: BlocProvider(
                create: (context) => PuzzleBloc(
                  4,
                )..add(
                    PuzzleInitialized(
                      shufflePuzzle: shufflePuzzle,
                    ),
                  ),
                child: const _Puzzle(
                  key: Key('puzzle_view_puzzle'),
                ),
              ),
            )),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return AudioControlListener(
      audioPlayer: tileAudioPlayer,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              theme.layoutDelegate.backgroundBuilder(state),
              const Positioned.fill(
                child: _PuzzleSections(
                  key: Key('puzzle_sections'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => const Center(
          child: _PuzzleLogo(),
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            children: const [
              _PuzzleLogo(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            children: const [
              _PuzzleLogo(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleLogo extends StatelessWidget {
  const _PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(
        height: 24,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 86,
        ),
      ),
      medium: (context, child) => const SizedBox(
        height: 29,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 104,
        ),
      ),
      large: (context, child) => const SizedBox(
        height: 32,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 114,
        ),
      ),
    );
  }
}

class _PuzzleSections extends StatelessWidget {
  const _PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => const _Page(
        orientation: PageOrientation.portrait,
      ),
      medium: (context, child) => const _Page(
        orientation: PageOrientation.portrait,
      ),
      smallWide: (context, child) => const _Page(
        orientation: PageOrientation.landscapeLow,
      ),
      mediumWide: (context, child) => const _Page(
        orientation: PageOrientation.landscapeLow,
      ),
      large: (context, child) => const _Page(
        orientation: PageOrientation.landscape,
      ),
    );
  }
}

const _puzzleBoardKey = Key('puzzle_board_stack');

enum PageOrientation {
  /// Taller than wide.
  portrait,

  /// Wider than tall.
  landscape,
  landscapeLow,
}

class _Page extends StatelessWidget {
  const _Page({required this.orientation, Key? key}) : super(key: key);
  final PageOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: theme.layoutDelegate.startSectionBuilder(state),
        ),
        Positioned.fill(
          child: PuzzleBoard(),
        ),
        if (orientation == PageOrientation.portrait)
          Align(
            alignment: Alignment.bottomCenter,
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        if (orientation == PageOrientation.landscape)
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Align(
              alignment: Alignment.centerLeft,
              child: theme.layoutDelegate.endSectionBuilder(state),
            ),
          ),
        if (orientation == PageOrientation.landscapeLow)
          Align(
            alignment: Alignment.bottomRight,
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
      ],
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    final tilesMap = <Tile, Widget>{};
    for (final tile in puzzle.tiles) {
      tilesMap[tile] = _PuzzleTile(
        key: Key('puzzle_tile_${tile.value.toString()}'),
        tile: tile,
      );
    }

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerBloc>().add(const TimerStopped());
        }
      },
      child: ResponsiveLayoutBuilder(
          defaultBuilder: (context, child) => Padding(
                padding: const EdgeInsets.only(top: 200),
                child: child,
              ),
          smallWide: (context, child) => Padding(
                padding: const EdgeInsets.only(top: 100),
                child: child,
              ),
          child: (_) {
            return PuzzleKeyboardHandler(
              child: theme.layoutDelegate.boardBuilder(
                size,
                tilesMap,
              ),
            );
          }),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}
