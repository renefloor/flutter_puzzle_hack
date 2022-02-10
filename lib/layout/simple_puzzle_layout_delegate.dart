import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/components/index.dart';
import 'package:very_good_slide_puzzle/layout/components/island_puzzle_tile.dart';
import 'package:very_good_slide_puzzle/layout/components/shuffle_button.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [IslandTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return SimpleStartSection(state: state);
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberOfMoves(state.numberOfMoves),
              const IslandPuzzleShuffleButton(),
              NumberOfTilesLeft(state.numberOfTilesLeft),
            ],
          ),
          medium: (_, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberOfMoves(state.numberOfMoves),
              const IslandPuzzleShuffleButton(),
              NumberOfTilesLeft(state.numberOfTilesLeft),
            ],
          ),
          large: (_, __) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const IslandPuzzleShuffleButton(),
                const Gap(32),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: NumberOfMoves(state.numberOfMoves),
                ),
                const Gap(32),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: NumberOfTilesLeft(state.numberOfTilesLeft),
                ),
              ],
            ),
          ),
        ),
        const Gap(32),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned.fill(
      child: Stack(
        children: const [
          BackgroundTop(),
          Clouds(start: 0.3, relativeHeight: 0.3, durationInSeconds: 40),
          Clouds(start: 0.8, relativeHeight: 0.15, durationInSeconds: 30),
          Clouds(start: 0, relativeHeight: 0, durationInSeconds: 50),
        ],
      ),
    );
  }

  @override
  Widget boardBuilder(int size, Map<Tile, Widget> tiles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        final Size boardSize;
        final Key boardKey;
        if (screenWidth <= PuzzleWidthBreakpoints.small) {
          boardSize = _BoardSize.small;
          boardKey = const Key('simple_puzzle_board_small');
        } else if (screenWidth <= PuzzleWidthBreakpoints.medium) {
          boardSize = _BoardSize.medium;
          boardKey = const Key('simple_puzzle_board_medium');
        } else if (screenWidth <= PuzzleWidthBreakpoints.large) {
          boardSize = _BoardSize.large;
          boardKey = const Key('simple_puzzle_board_large');
        } else {
          boardSize = _BoardSize.xLarge;
          boardKey = const Key('simple_puzzle_board_xlarge');
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.fromSize(
              size: boardSize,
              child: SimplePuzzleBoard(
                key: boardKey,
                size: size,
                tiles: tiles,
              ),
            )
          ],
        );
      },
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.fromSize(
            size: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.fromSize(
            size: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.fromSize(
            size: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
          xLarge: (_, __) => SizedBox.fromSize(
            size: _BoardSize.xLarge,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_xlarge'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          const PuzzleName(),
          SimplePuzzleTitle(
            status: state.puzzleStatus,
          ),
        ],
      ),
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double aspectRatio = 1.5;
  static double _small = 312;
  static Size small = Size(_small, _small / aspectRatio);
  static double _medium = 424;
  static Size medium = Size(_medium, _medium / aspectRatio);
  static double _large = 472;
  static Size large = Size(_large, _large / aspectRatio);
  static double _xLarge = 700;
  static Size xLarge = Size(_xLarge, _xLarge / aspectRatio);
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final Map<Tile, Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Iceberg(),
            ...tiles.keys
                .map(
                  (e) => AnimatedPositioned(
                    key: ValueKey(e.value),
                    left: _calculateLeft(constraints, e.currentPosition),
                    top: _calculateTop(constraints, e.currentPosition),
                    duration: const Duration(milliseconds: 400),
                    child: SizedBox(
                      width: _calculateBlockWidth(constraints),
                      child: tiles[e],
                    ),
                  ),
                )
                .toList(),
            const Boat(),
          ],
        );
      },
    );
  }

  double _calculateBlockWidth(BoxConstraints constraints) {
    return constraints.maxWidth / 4;
  }

  double _calculateLeft(BoxConstraints constraints, Position position) {
    final blockWidth = _calculateBlockWidth(constraints);
    return (position.x - 1).toDouble() * blockWidth / 2 +
        (position.y - 1).toDouble() * blockWidth / 2;
  }

  double _calculateTop(BoxConstraints constraints, Position position) {
    final blockWidth = _calculateBlockWidth(constraints);
    return (constraints.maxWidth / 3 - blockWidth * (1 / 2)) +
        (position.y - 1) * (blockWidth * (3 / 10)) -
        (position.x - 1) * (blockWidth * (3 / 10));
  }
}

abstract class _TileFontSize {
  static double small = 24;
  static double medium = 30;
  static double large = 40;
}
