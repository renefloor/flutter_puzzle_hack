import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SimplePuzzleShuffleButton(),
          medium: (_, child) => const SimplePuzzleShuffleButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox(
            width: 184,
            height: 118,
            child: Image.asset(
              'assets/images/simple_dash_small.png',
              key: const Key('simple_puzzle_dash_small'),
            ),
          ),
          medium: (_, __) => SizedBox(
            width: 380.44,
            height: 214,
            child: Image.asset(
              'assets/images/simple_dash_medium.png',
              key: const Key('simple_puzzle_dash_medium'),
            ),
          ),
          large: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 53),
            child: SizedBox(
              width: 568.99,
              height: 320,
              child: Image.asset(
                'assets/images/simple_dash_large.png',
                key: const Key('simple_puzzle_dash_large'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, Map<Tile, Widget> tiles) {
    return Column(
      children: [
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
          xLarge: (_, __) => SizedBox.square(
            dimension: _BoardSize.xLarge,
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
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleShuffleButton(),
        ),
      ],
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
  static double small = 312;
  static double medium = 424;
  static double large = 472;
  static double xLarge = 700;
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
          children: [
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
    return (constraints.maxWidth / 2 - blockWidth * (1 / 2)) +
        (position.y - 1) * (blockWidth * (3 / 10)) -
        (position.x - 1) * (blockWidth * (3 / 10));
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTileState();
}

class _SimplePuzzleTileState extends State<SimplePuzzleTile> {
  var _isTapped = false;

  bool get _isShuffling => widget.state.puzzleStatus == PuzzleStatus.shuffling;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var position = 0.0;
      if (_isTapped) position += constraints.maxWidth * 0.1;
      if (_isShuffling) position += constraints.maxWidth * 1.2;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            top: position,
            left: 0,
            right: 0,
            curve: _isTapped ? Curves.linear : Curves.elasticOut,
            duration: Duration(
              milliseconds: _isTapped
                  ? 50
                  : _isShuffling
                      ? 5000
                      : 500,
            ),
            child: IgnorePointer(child: Image.asset('assets/images/block.png')),
          ),
          if (!_isShuffling)
            Align(
              alignment: Alignment.topCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: IgnorePointer(
                  child: Center(
                    child: Transform.rotate(
                      angle: -math.pi / 4,
                      child: Text(
                        '${widget.tile.value}',
                        style: TextStyle(
                          color: widget.tile.currentPosition ==
                                  widget.tile.correctPosition
                              ? Colors.greenAccent
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          IgnorePointer(
            child: _Water(
              width: constraints.maxWidth,
            ),
          ),
          GestureDetector(
            onTapDown: (_) => setState(() => _isTapped = true),
            onTapUp: (_) => setState(() => _isTapped = false),
            onTapCancel: () => setState(() => _isTapped = false),
            onTap: widget.state.puzzleStatus == PuzzleStatus.incomplete
                ? () => context.read<PuzzleBloc>().add(TileTapped(widget.tile))
                : null,
            child: Padding(
              padding: EdgeInsets.only(top: constraints.maxWidth * 0.05),
              child: const _Top(),
            ),
          ),
        ],
      );
    });
  }
}

class _Top extends StatelessWidget {
  const _Top({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: CustomPaint(painter: _TopShape()),
    );
  }
}

class _TopShape extends CustomPainter {
  _TopShape();

  Paint painter = Paint();
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool? hitTest(Offset position) {
    final path = _path;
    if (path == null) return false;
    return path.contains(position);
  }
}

class _Water extends StatelessWidget {
  const _Water({
    required this.width,
    Key? key,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width * 2,
      width: width,
      margin: EdgeInsets.only(top: width * (11 / 16)),
      child: Row(
        children: const [
          Expanded(child: _WaterGradient(skew: 0.5)),
          Expanded(child: _WaterGradient(skew: -0.5))
        ],
      ),
    );
  }
}

class _WaterGradient extends StatelessWidget {
  const _WaterGradient({required this.skew, Key? key}) : super(key: key);
  final double skew;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewY(skew),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3],
            colors: [Colors.blue.withOpacity(0.5), Colors.blue],
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: Colors.green,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}
