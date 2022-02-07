import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

class IslandPuzzleShuffleButton extends StatefulWidget {
  const IslandPuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  _IslandPuzzleShuffleButtonState createState() =>
      _IslandPuzzleShuffleButtonState();
}

const _animationDuration = Duration(milliseconds: 100);

class _IslandPuzzleShuffleButtonState extends State<IslandPuzzleShuffleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..addListener(() {
        setState(() {});
      });
    _xAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInQuad));
    _yAnimation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInQuad));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dx = _xAnimation.value;
    final dy = _yAnimation.value;

    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapCancel: () => _controller.reverse(),
        onTapUp: (_) => _controller.reverse(),
        onTap: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9BCAE1),
            border: Border.all(color: _borderColor, width: 2),
            borderRadius: BorderRadius.circular(45),
            boxShadow: createShadow(dx, dy),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ),
    );
  }

  List<BoxShadow> createShadow(double dx, double dy) {
    return [
      BoxShadow(
        color: _borderColor,
        offset: Offset(2 - dx, 8 - dy),
      ),
    ];
  }
}

const _borderColor = Color(0xFF75B9D9);
