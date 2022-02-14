import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/components/index.dart';
import 'package:very_good_slide_puzzle/layout/components/island_puzzle_tile.dart';
import 'package:very_good_slide_puzzle/layout/components/shuffle_button.dart';
import 'package:very_good_slide_puzzle/layout/components/waves.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

import 'components/floating_object.dart';
import 'components/paper_plane.dart';
import 'components/sun.dart';

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
              ShuffleAndMuteButtons(),
              NumberOfTilesLeft(state.numberOfTilesLeft),
            ],
          ),
          medium: (_, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberOfMoves(state.numberOfMoves),
              ShuffleAndMuteButtons(),
              NumberOfTilesLeft(state.numberOfTilesLeft),
            ],
          ),
          smallWide: (_, __) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisSize: MainAxisSize.max,
              children: [
                ShuffleAndMuteButtons(),
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
          mediumWide: (_, __) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShuffleAndMuteButtons(),
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
          large: (_, __) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShuffleAndMuteButtons(),
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
          SunAndMoon(),
          Clouds(start: 0.7, relativeDistance: 0.25),
          Clouds(start: 0.6, relativeDistance: 0.5),
          Clouds(start: 0.3, relativeDistance: 0),
          // Clouds(start: 0.8, relativeHeight: 0.15, durationInSeconds: 30),
          // Clouds(start: 0, relativeHeight: 0, durationInSeconds: 50),
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
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);

        final double floatingObjectSize;
        final Size boardSize;
        final Key boardKey;
        var bottomPadding = 100.0;

        if (screenWidth > PuzzleWidthBreakpoints.small &&
            screenHeight <= PuzzleHeightBreakpoints.small &&
            screenWidth <= PuzzleWidthBreakpoints.smallWide) {
          bottomPadding = 50;
        }
        bool hasRock = false;

        if (screenWidth <= PuzzleWidthBreakpoints.small) {
          boardSize = _BoardSize.small;
          boardKey = const Key('simple_puzzle_board_small');
          floatingObjectSize = 75;
        } else if (screenWidth <= PuzzleWidthBreakpoints.medium) {
          boardSize = _BoardSize.medium;
          boardKey = const Key('simple_puzzle_board_medium');
          floatingObjectSize = 100;
        } else if (screenWidth <= PuzzleWidthBreakpoints.large) {
          boardSize = _BoardSize.large;
          boardKey = const Key('simple_puzzle_board_large');
          floatingObjectSize = 125;
          hasRock = true;
        } else {
          boardSize = _BoardSize.xLarge;
          boardKey = const Key('simple_puzzle_board_xlarge');
          floatingObjectSize = 150;
          hasRock = true;
        }
        final factory = FloatingObjectFactory(
          puzzleSize: boardSize,
          screenSize: screenSize,
          childSize: floatingObjectSize,
          bottomPadding: bottomPadding,
        );

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            factory.ne(
              Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  Expanded(child: Image.asset('assets/images/iceberg.png')),
                ],
              ),
              speed: 0.7,
            ),
            factory.nw(const PaperPlane(), speed: 2),
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: SizedBox.fromSize(
                size: boardSize,
                child: SimplePuzzleBoard(
                  key: boardKey,
                  size: size,
                  tiles: tiles,
                ),
              ),
            ),
            if (hasRock)
              Positioned(
                right: screenSize.width / 2 - boardSize.width * 0.75,
                top: (screenSize.height - 200) / 2,
                width: 200,
                child: Image.asset('assets/images/rock.png'),
              ),
            factory.se(Image.asset('assets/images/submarine.png')),
            Waves(
              right: screenSize.width / 2 - boardSize.width * 0.9,
              top: screenSize.height * 0.75,
            ),
            Waves(
              top: screenSize.height * 0.65,
              left: screenSize.width / 2 - boardSize.width * 0.8,
            ),
            Waves(
              top: screenSize.height / 2 + boardSize.height * 0.5,
              left: screenSize.width / 2 - boardSize.width * 0.2,
            ),
            factory.sw(Image.asset('assets/images/boat_new.png'), speed: 2.5),
          ],
        );
      },
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state, AudioPlayer audioPlayer) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
        audioPlayer: audioPlayer,
      ),
      medium: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
        audioPlayer: audioPlayer,
      ),
      large: (_, __) => IslandPuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
        audioPlayer: audioPlayer,
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
  static double _small = 400;
  static Size small = Size(_small, _small / aspectRatio);
  static double _medium = 550;
  static Size medium = Size(_medium, _medium / aspectRatio);
  static double _large = 700;
  static Size large = Size(_large, _large / aspectRatio);
  static double _xLarge = 1000;
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
            // const Iceberg(),
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
            // const Boat(),
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
    return (position.x + position.y - 2).toDouble() * blockWidth / 2 * 1.02;
  }

  double _calculateTop(BoxConstraints constraints, Position position) {
    final blockWidth = _calculateBlockWidth(constraints);
    return (constraints.maxWidth / 3 - blockWidth * (1 / 2)) +
        (position.y - 1) * (blockWidth * (29 / 100)) -
        (position.x - 1) * (blockWidth * (29 / 100));
  }
}

abstract class _TileFontSize {
  static double small = 24;
  static double medium = 30;
  static double large = 40;
}
