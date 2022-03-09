import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:island_slide_puzzle/audio/audio_player_factory.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool supportsAudio() {
  return kIsWeb || (!Platform.isLinux && !Platform.isWindows);
}

/// Gets a new instance of [PuzzleAudioPlayer].
PuzzleAudioPlayer getAudioPlayer() {
  if (supportsAudio()) {
    return JustAudioPlayer();
  }
  return NoopAudioPlayer();
}

class AudioControlBloc extends Bloc<AudioControlEvent, AudioControlState> {
  AudioControlBloc({required this.repository})
      : super(const AudioControlState()) {
    on<AudioToggled>(_onAudioToggled);
    repository.isMuted().then((value) {
      if (value != state.muted) add(const AudioToggled());
    });
  }

  AudioStateRepository repository;

  void _onAudioToggled(AudioToggled event, Emitter<AudioControlState> emit) {
    final isMuted = !state.muted;
    repository.save(isMuted: isMuted);
    emit(AudioControlState(muted: isMuted));
  }
}

const _audioPrefsKey = 'audio_muted';

class AudioStateRepository {
  final _prefs = SharedPreferences.getInstance();

  Future<bool> isMuted() async {
    return (await _prefs).getBool(_audioPrefsKey) ?? false;
  }

  Future<bool> save({required bool isMuted}) async {
    return (await _prefs).setBool(_audioPrefsKey, isMuted);
  }
}

abstract class AudioControlEvent extends Equatable {
  const AudioControlEvent();

  @override
  List<Object> get props => [];
}

class AudioToggled extends AudioControlEvent {
  const AudioToggled() : super();
}

class AudioControlState extends Equatable {
  const AudioControlState({
    this.muted = false,
  });

  /// Whether the audio is muted.
  final bool muted;

  @override
  List<Object> get props => [muted];
}
