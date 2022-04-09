import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:island_slide_puzzle/audio/audio_control_listener.dart';
import 'package:island_slide_puzzle/l10n/l10n.dart';
import 'package:island_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:island_slide_puzzle/typography/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../audio/audio_control_bloc.dart';
import '../../audio/audio_player_factory.dart';
import '../../download/download_url.dart';

class ShuffleAndSettingsButtons extends StatelessWidget {
  ShuffleAndSettingsButtons({Key? key}) : super(key: key) {
    _audioPlayer.setAsset('assets/sounds/splash_big2.mp3');
  }

  final _audioPlayer = getAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AudioControlListener(
          audioPlayer: _audioPlayer,
          child: IslandPuzzleShuffleButton(audioPlayer: _audioPlayer),
        ),
        const SizedBox.square(dimension: 8),
        const SettingsButton(),
      ],
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IslandPuzzleButton(
      onTap: () => _showMyDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Image.asset(
          'assets/images/settings_icon.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    final bloc = context.read<AudioControlBloc>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.only(top: 30, bottom: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF8DC6D0),
                  borderRadius: BorderRadius.circular(16.0),
                  border:
                      Border.all(width: 2.0, color: const Color(0xFF336083)),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 24.0,
                  ),
                  children: _dialogContent(context, bloc: bloc),
                ),
              ),
              Image.asset(
                'assets/images/settings_banner.png',
                width: 200,
              ),
              Positioned(
                bottom: 0,
                child: IslandPuzzleButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text('CLOSE', style: TextStyle(height: 1)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _dialogContent(
    BuildContext context, {
    required AudioControlBloc bloc,
  }) {
    final downloadUrl = getDownloadUrl();
    return [
      if (supportsAudio()) ...[
        const SizedBox(height: 40.0),
        BlocBuilder<AudioControlBloc, AudioControlState>(
          bloc: bloc,
          builder: (context, state) => DialogButton(
            image: state.muted
                ? 'assets/images/volume_off.png'
                : 'assets/images/volume_on.png',
            text: 'Sound',
            state: state.muted ? 'OFF' : 'ON',
            onTap: () => bloc.add(const AudioToggled()),
          ),
        ),
      ],
      if (downloadUrl != null) ...[
        const SizedBox(height: 16.0),
        DialogButton(
          image: 'assets/images/download_icon.png',
          text: 'Download',
          state: '',
          onTap: () => launch(downloadUrl),
        ),
      ],
      const SizedBox(height: 32.0),
      Text(
        'Credits',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'Designed by Mathieu Nauleau and developed by Rene Floor.\n\n'
          'Built on top of the Very Good Ventures Slide Puzzle example.\n\n'
          'Sounds from zapsplat.com',
        ),
      ),
      const SizedBox(height: 16.0),
    ];
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    required this.image,
    required this.text,
    required this.state,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String image;
  final String text;
  final String state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IslandPuzzleButton(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Image.asset(
              image,
              width: 24,
              height: 24,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text, textAlign: TextAlign.left),
          ),
        ),
        Text(state),
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
  final PuzzleAudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    final status = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);

    return AudioControlListener(
      audioPlayer: audioPlayer,
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) => audioPlayer.play(),
        listenWhen: (previous, current) =>
            previous.puzzleStatus != PuzzleStatus.shuffling &&
            current.puzzleStatus == PuzzleStatus.shuffling,
        child: IslandPuzzleButton(
          onTap: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
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
  bool isHovered = false;

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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapCancel: () => _controller.reverse(),
          onTapUp: (_) => _controller.reverse(),
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color:
                  isHovered ? const Color(0xFF2EBED4) : const Color(0xFF35D1E9),
              border: Border.all(color: _borderColor, width: 2),
              borderRadius: BorderRadius.circular(45),
              boxShadow: createShadow(dx, dy),
            ),
            child: widget.child,
          ),
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

class Constants {
  static const padding = 16.0;
}
