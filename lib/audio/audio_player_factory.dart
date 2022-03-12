import 'package:just_audio/just_audio.dart';

abstract class PuzzleAudioPlayer {
  bool get playing;
  Future<void> seek(Duration duration);
  Future<void> play();
  Future<Duration?> setAsset(String asset);
  Future<void> setVolume(double volume);
}

class NoopAudioPlayer implements PuzzleAudioPlayer {
  @override
  Future<void> play() {
    return Future.value();
  }

  @override
  bool get playing => false;

  @override
  Future<void> seek(Duration duration) {
    return Future.value();
  }

  @override
  Future<Duration?> setAsset(String asset) {
    return Future.value(null);
  }

  @override
  Future<void> setVolume(double volume) {
    return Future.value();
  }
}

class JustAudioPlayer implements PuzzleAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  bool get playing => _audioPlayer.playing;

  @override
  Future<void> seek(Duration duration) {
    return _audioPlayer.seek(duration);
  }

  @override
  Future<Duration?> setAsset(String asset) {
    return _audioPlayer.setAsset(asset);
  }

  @override
  Future<void> setVolume(double volume) {
    return _audioPlayer.setVolume(volume);
  }
}
