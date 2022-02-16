// ignore_for_file: flutter_style_todos

import 'dart:io' show Platform;

import 'package:audio_session/src/android.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class NoopAudioPlayer implements AudioPlayer {
  @override
  int? get androidAudioSessionId => throw UnimplementedError();

  @override
  Stream<int?> get androidAudioSessionIdStream => throw UnimplementedError();

  @override
  AudioSource? get audioSource => throw UnimplementedError();

  @override
  bool get automaticallyWaitsToMinimizeStalling => throw UnimplementedError();

  @override
  Duration get bufferedPosition => throw UnimplementedError();

  @override
  Stream<Duration> get bufferedPositionStream => throw UnimplementedError();

  @override
  bool get canUseNetworkResourcesForLiveStreamingWhilePaused => throw UnimplementedError();

  @override
  Stream<Duration> createPositionStream({int steps = 800, Duration minPeriod = const Duration(milliseconds: 200), Duration maxPeriod = const Duration(milliseconds: 200)}) {
    throw UnimplementedError();
  }

  @override
  int? get currentIndex => throw UnimplementedError();

  @override
  Stream<int?> get currentIndexStream => throw UnimplementedError();

  @override
  Future<void> dispose() {
    throw UnimplementedError();
  }

  @override
  Duration? get duration => throw UnimplementedError();

  @override
  Future<Duration?>? get durationFuture => throw UnimplementedError();

  @override
  Stream<Duration?> get durationStream => throw UnimplementedError();

  @override
  List<int>? get effectiveIndices => throw UnimplementedError();

  @override
  bool get hasNext => throw UnimplementedError();

  @override
  bool get hasPrevious => throw UnimplementedError();

  @override
  IcyMetadata? get icyMetadata => throw UnimplementedError();

  @override
  Stream<IcyMetadata?> get icyMetadataStream => throw UnimplementedError();

  @override
  Future<Duration?> load() {
    throw UnimplementedError();
  }

  @override
  LoopMode get loopMode => throw UnimplementedError();

  @override
  Stream<LoopMode> get loopModeStream => throw UnimplementedError();

  @override
  int? get nextIndex => throw UnimplementedError();

  @override
  Future<void> pause() {
    throw UnimplementedError();
  }

  @override
  double get pitch => throw UnimplementedError();

  @override
  Stream<double> get pitchStream => throw UnimplementedError();

  @override
  Future<void> play() {
    return Future.value();
  }

  @override
  PlaybackEvent get playbackEvent => throw UnimplementedError();

  @override
  Stream<PlaybackEvent> get playbackEventStream => throw UnimplementedError();

  @override
  PlayerState get playerState => throw UnimplementedError();

  @override
  Stream<PlayerState> get playerStateStream => throw UnimplementedError();

  @override
  bool get playing => false;

  @override
  Stream<bool> get playingStream => throw UnimplementedError();

  @override
  Duration get position => throw UnimplementedError();

  @override
  Stream<Duration> get positionStream => throw UnimplementedError();

  @override
  double get preferredPeakBitRate => throw UnimplementedError();

  @override
  int? get previousIndex => throw UnimplementedError();

  @override
  ProcessingState get processingState => throw UnimplementedError();

  @override
  Stream<ProcessingState> get processingStateStream => throw UnimplementedError();

  @override
  Future<void> seek(Duration? position, {int? index}) {
    throw UnimplementedError();
  }

  @override
  Future<void> seekToNext() {
    throw UnimplementedError();
  }

  @override
  Future<void> seekToPrevious() {
    throw UnimplementedError();
  }

  @override
  List<IndexedAudioSource>? get sequence => throw UnimplementedError();

  @override
  SequenceState? get sequenceState => throw UnimplementedError();

  @override
  Stream<SequenceState?> get sequenceStateStream => throw UnimplementedError();

  @override
  Stream<List<IndexedAudioSource>?> get sequenceStream => throw UnimplementedError();

  @override
  Future<void> setAndroidAudioAttributes(AndroidAudioAttributes audioAttributes) {
    throw UnimplementedError();
  }

  @override
  Future<Duration?> setAsset(String assetPath, {bool preload = true, Duration? initialPosition}) {
    return Future.value(null);
  }

  @override
  Future<Duration?> setAudioSource(AudioSource source, {bool preload = true, int? initialIndex, Duration? initialPosition}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setAutomaticallyWaitsToMinimizeStalling(bool automaticallyWaitsToMinimizeStalling) {
    throw UnimplementedError();
  }

  @override
  Future<void> setCanUseNetworkResourcesForLiveStreamingWhilePaused(bool canUseNetworkResourcesForLiveStreamingWhilePaused) {
    throw UnimplementedError();
  }

  @override
  Future<Duration?> setClip({Duration? start, Duration? end}) {
    throw UnimplementedError();
  }

  @override
  Future<Duration?> setFilePath(String filePath, {Duration? initialPosition, bool preload = true}) {
    // TODO: implement setFilePath
    throw UnimplementedError();
  }

  @override
  Future<void> setLoopMode(LoopMode mode) {
    // TODO: implement setLoopMode
    throw UnimplementedError();
  }

  @override
  Future<void> setPitch(double pitch) {
    // TODO: implement setPitch
    throw UnimplementedError();
  }

  @override
  Future<void> setPreferredPeakBitRate(double preferredPeakBitRate) {
    // TODO: implement setPreferredPeakBitRate
    throw UnimplementedError();
  }

  @override
  Future<void> setShuffleModeEnabled(bool enabled) {
    // TODO: implement setShuffleModeEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> setSkipSilenceEnabled(bool enabled) {
    // TODO: implement setSkipSilenceEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> setSpeed(double speed) {
    // TODO: implement setSpeed
    throw UnimplementedError();
  }

  @override
  Future<Duration?> setUrl(String url, {Map<String, String>? headers, Duration? initialPosition, bool preload = true}) {
    // TODO: implement setUrl
    throw UnimplementedError();
  }

  @override
  Future<void> setVolume(double volume) {
    return Future.value();
  }

  @override
  Future<void> shuffle() {
    // TODO: implement shuffle
    throw UnimplementedError();
  }

  @override
  // TODO: implement shuffleIndices
  List<int>? get shuffleIndices => throw UnimplementedError();

  @override
  // TODO: implement shuffleIndicesStream
  Stream<List<int>?> get shuffleIndicesStream => throw UnimplementedError();

  @override
  // TODO: implement shuffleModeEnabled
  bool get shuffleModeEnabled => throw UnimplementedError();

  @override
  // TODO: implement shuffleModeEnabledStream
  Stream<bool> get shuffleModeEnabledStream => throw UnimplementedError();

  @override
  // TODO: implement skipSilenceEnabled
  bool get skipSilenceEnabled => throw UnimplementedError();

  @override
  // TODO: implement skipSilenceEnabledStream
  Stream<bool> get skipSilenceEnabledStream => throw UnimplementedError();

  @override
  // TODO: implement speed
  double get speed => throw UnimplementedError();

  @override
  // TODO: implement speedStream
  Stream<double> get speedStream => throw UnimplementedError();

  @override
  Future<void> stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }

  @override
  // TODO: implement volume
  double get volume => throw UnimplementedError();

  @override
  // TODO: implement volumeStream
  Stream<double> get volumeStream => throw UnimplementedError();

}