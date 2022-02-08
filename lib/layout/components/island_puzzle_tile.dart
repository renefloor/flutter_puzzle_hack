import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/components/mouse_region_hittest.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'dart:math' as math;

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
      if (_isTapped) {
        position += 0.1;
      } else if (_isHovered) {
        position += 0.01;
      }
      if (_isShuffling) position += 0.8;

      return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: position),
          curve: _isTapped ? Curves.linear : Curves.elasticOut,
          duration: Duration(
            milliseconds: _isTapped
                ? 50
                : _isShuffling
                    ? 10000
                    : 500,
          ),
          builder: (context, value, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: value * constraints.maxWidth,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Stack(
                      children: [
                        Image.asset('assets/images/block.png'),
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
                              child: Image.asset(
                                  'assets/images/tile_correct.png')),
                        ),
                      ],
                    ),
                  ),
                ),
                _Water(
                  width: constraints.maxWidth,
                  relativeDepth: value,
                ),
                Padding(
                  padding: EdgeInsets.only(top: constraints.maxWidth * 0.07),
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTapDown: (_) => setState(() => _isTapped = true),
                    onTapUp: (_) => setState(() => _isTapped = false),
                    onTapCancel: () => setState(() => _isTapped = false),
                    onTap: widget.state.puzzleStatus == PuzzleStatus.incomplete
                        ? () => context
                            .read<PuzzleBloc>()
                            .add(TileTapped(widget.tile))
                        : null,
                    child: MouseRegionHittest(
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: Semantics(
                        sortKey: OrdinalSortKey(
                          widget.tile.currentPosition.y * 100.0 +
                              widget.tile.currentPosition.x,
                          name: 'tile',
                        ),
                        label: context.l10n.puzzleTileLabelText(
                          widget.tile.value.toString(),
                          widget.tile.currentPosition.x.toString(),
                          widget.tile.currentPosition.y.toString(),
                        ),
                        child: const _Top(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }
}

class _Top extends StatelessWidget {
  const _Top({this.color = Colors.transparent, Key? key}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: CustomPaint(painter: _TopShape(color)),
    );
  }
}

class _TopShape extends CustomPainter {
  _TopShape(Color color) {
    _strokePainter = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke;
    _fillPainter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  Paint _strokePainter = Paint();
  Paint _fillPainter = Paint();
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2)
      ..close();

    if (kDebugMode) {
      canvas.drawPath(_path!, _strokePainter);
    }
    canvas.drawPath(_path!, _fillPainter);
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
    required this.relativeDepth,
    Key? key,
  }) : super(key: key);
  final double width;
  final double relativeDepth;

  static const _waterLevel = 11 / 16;

  @override
  Widget build(BuildContext context) {
    final relativeHeightOfIsland = 8 / 16 + relativeDepth;
    final heightOfIsland = width * relativeHeightOfIsland;
    final heightOfWater = width * _waterLevel;

    final relativeUnderWater =
        math.max<double>(0, relativeHeightOfIsland - _waterLevel);
    final waterColor =
        context.select((ThemeBloc bloc) => bloc.state.theme).backgroundColor;
    final double waterOpacity;
    if (relativeUnderWater < 0.0) {
      waterOpacity = 0.0;
    } else if (relativeUnderWater < _startOfDarkWater) {
      waterOpacity = Tween<double>(begin: _startOpacity, end: 1)
          .transform(relativeUnderWater / _startOfDarkWater);
    } else {
      waterOpacity = 1.0;
    }

    return IgnorePointer(
      child: SizedBox(
        height: width * 3,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            if (relativeUnderWater > 0.0)
              Positioned(
                left: -0.3,
                top: width * (relativeDepth + 0.07),
                right: -0.3,
                child: _Top(color: waterColor.withOpacity(waterOpacity)),
              ),
            Positioned(
              left: 0,
              top: math.max(heightOfIsland, heightOfWater) - 2,
              bottom: 0,
              right: (width / 2) - 1,
              child: _WaterGradient(
                skew: 0.5,
                removeFirstPart: relativeUnderWater,
              ),
            ),
            Positioned(
              left: (width / 2) - 1,
              right: 0,
              top: math.max(heightOfIsland, heightOfWater) - 2,
              bottom: 0,
              child: _WaterGradient(
                skew: -0.5,
                removeFirstPart: relativeUnderWater,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _startOfDarkWater = 0.3;
const _startOpacity = 0.4;

class _WaterGradient extends StatelessWidget {
  const _WaterGradient(
      {required this.skew, required this.removeFirstPart, Key? key})
      : super(key: key);
  final double skew;
  final double removeFirstPart;

  bool get hasTransparentWater => removeFirstPart < _startOfDarkWater;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final waterColor = theme.backgroundColor;
    final startOpacity = Tween<double>(begin: _startOpacity, end: 1)
        .transform(removeFirstPart / _startOfDarkWater);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewY(skew),
      child: Container(
        decoration: BoxDecoration(
          gradient: hasTransparentWater
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [removeFirstPart, _startOfDarkWater],
                  colors: [waterColor.withOpacity(startOpacity), waterColor],
                )
              : null,
          color: hasTransparentWater ? null : waterColor,
        ),
      ),
    );
  }
}
