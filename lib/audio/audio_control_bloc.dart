import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:island_slide_puzzle/audio/audio_player_factory.dart';
import 'package:just_audio/just_audio.dart';

bool supportsAudio(){
  return kIsWeb || (!Platform.isLinux && !Platform.isWindows);
}

/// Gets a new instance of [AudioPlayer].
AudioPlayer getAudioPlayer() {
  if(supportsAudio()){
    return AudioPlayer();
  }
  return NoopAudioPlayer();
}

class AudioControlBloc extends Bloc<AudioControlEvent, AudioControlState> {
  AudioControlBloc() : super(const AudioControlState()) {
    on<AudioToggled>(_onAudioToggled);
  }

  void _onAudioToggled(AudioToggled event, Emitter<AudioControlState> emit) {
    emit(AudioControlState(muted: !state.muted));
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
