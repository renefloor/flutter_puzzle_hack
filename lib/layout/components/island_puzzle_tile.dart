import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class IslandPuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const IslandPuzzleTile({
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
  State<IslandPuzzleTile> createState() => _IslandPuzzleTileState();
}

class _IslandPuzzleTileState extends State<IslandPuzzleTile> {
  var _isTapped = false;
  var _isHovered = false;

  bool get _isShuffling => widget.state.puzzleStatus == PuzzleStatus.shuffling;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var position = 0.0;
      if (_isTapped)
        position += constraints.maxWidth * 0.1;
      else if (_isHovered) position += constraints.maxWidth * 0.01;
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
            child: IgnorePointer(
                child: Stack(children: [
              Image.asset('assets/images/block.png'),
              if (!_isShuffling) ...[
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                      curve: Curves.easeInQuad,
                      duration: const Duration(milliseconds: 400),
                      opacity: widget.tile.correctPosition ==
                              widget.tile.currentPosition
                          ? 0
                          : 1,
                      child: Image.asset(
                          'assets/images/Number=${widget.tile.value}.png')),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                      curve: Curves.easeInQuad,
                      duration: const Duration(milliseconds: 400),
                      opacity: widget.tile.correctPosition ==
                              widget.tile.currentPosition
                          ? 1
                          : 0,
                      child: Image.asset('assets/images/tile_correct.png')),
                ),
              ]
            ])),
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
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: Padding(
                padding: EdgeInsets.only(top: constraints.maxWidth * 0.05),
                child: const _Top(),
              ),
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
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final waterColor = theme.backgroundColor;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewY(skew),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3],
            colors: [waterColor.withOpacity(0.5), waterColor],
          ),
        ),
      ),
    );
  }
}
