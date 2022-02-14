import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:very_good_slide_puzzle/audio/audio_control_listener.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

import '../../audio/audio_control_bloc.dart';

class ShuffleAndMuteButtons extends StatelessWidget {
  ShuffleAndMuteButtons({Key? key}) : super(key: key) {
    _audioPlayer.setAsset('assets/sounds/splash_big2.mp3');
  }
  final _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AudioControlListener(
          audioPlayer: _audioPlayer,
          child: IslandPuzzleShuffleButton(audioPlayer: _audioPlayer),
        ),
        const SizedBox.square(dimension: 8),
        const MuteButton(),
      ],
    );
  }
}

class MuteButton extends StatelessWidget {
  const MuteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final muted = context.select((AudioControlBloc bloc) => bloc.state.muted);
    return IslandPuzzleButton(
      onTap: () => context.read<AudioControlBloc>().add(const AudioToggled()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Image.asset(
          muted
              ? 'assets/images/volume_off.png'
              : 'assets/images/volume_on.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}

class IslandPuzzleShuffleButton extends StatelessWidget {
  const IslandPuzzleShuffleButton({required this.audioPlayer, Key? key})
      : super(key: key);
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    final status = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);

    return AudioControlListener(
      audioPlayer: audioPlayer,
      child: IslandPuzzleButton(
        onTap: () {
          audioPlayer.play();
          context.read<PuzzleBloc>().add(const PuzzleReset());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/shuffle_icon.png',
                width: 24,
                height: 24,
              ),
              const Gap(10),
              Text(
                status == PuzzleStatus.start
                    ? context.l10n.puzzleStart
                    : context.l10n.puzzleShuffle,
                style: PuzzleTextStyle.headline4.copyWith(
                  color: const Color(0xFF284A65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _animationDuration = Duration(milliseconds: 100);
const double _xShadow = 2;
const double _yShadow = 6;
const _borderColor = Color(0xFF284A65);

class IslandPuzzleButton extends StatefulWidget {
  const IslandPuzzleButton({
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final VoidCallback onTap;

  @override
  _IslandPuzzleButtonState createState() => _IslandPuzzleButtonState();
}

class _IslandPuzzleButtonState extends State<IslandPuzzleButton>
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
      end: _xShadow,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInQuad));
    _yAnimation = Tween<double>(
      begin: 0,
      end: _yShadow,
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
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9BCAE1),
            border: Border.all(color: _borderColor, width: 2),
            borderRadius: BorderRadius.circular(45),
            boxShadow: createShadow(dx, dy),
          ),
          child: widget.child,
        ),
      ),
    );
  }

  List<BoxShadow> createShadow(double dx, double dy) {
    return [
      BoxShadow(
        color: _borderColor,
        offset: Offset(_xShadow - dx, _yShadow - dy),
      ),
    ];
  }
}
