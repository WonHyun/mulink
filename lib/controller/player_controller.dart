import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:audio_service/audio_service.dart';

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist;
}

enum PlayButtonState {
  paused,
  playing,
  loading,
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

class PlayerController extends GetxController {
  final _audioHandler = getIt<CustomAudioHandler>();

  bool _isShuffled = false;
  RepeatState _repeatState = RepeatState.off;
  PlayButtonState _playButtonState = PlayButtonState.paused;
  ProgressBarState _progressBarState = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  bool get isShuffled => _isShuffled;
  RepeatState get repeatState => _repeatState;
  PlayButtonState get playButtonState => _playButtonState;
  ProgressBarState get progressBarState => _progressBarState;

  double _volume = 0.8;
  double _beforeMuteVolume = 0.8;
  double _speed = 1.0;
  bool _isMute = false;

  double get volume => _volume;
  double get speed => _speed;
  bool get isMute => _isMute;

  PlayerController() {
    _listenToPlaybackState();
    _listenToPosition();
    _listenToVolume();
    _listenToSpeed();
    _listenToLoopMode();
    _listenToShuffleMode();

    setVolume(_volume);
    setSpeed(_speed);
  }

  void _listenToShuffleMode() {
    _audioHandler.shuffleModeEnabledStream.listen((isShuffled) {
      _isShuffled = isShuffled;
      update();
    });
  }

  void _listenToLoopMode() {
    _audioHandler.loopModeStream.listen((loopMode) {
      switch (loopMode) {
        case LoopMode.off:
          _repeatState = RepeatState.off;
        case LoopMode.all:
          _repeatState = RepeatState.repeatPlaylist;
        case LoopMode.one:
          _repeatState = RepeatState.repeatSong;
        default:
          _repeatState = RepeatState.off;
      }
      update();
    });
  }

  void _listenToSpeed() {
    _audioHandler.speedStream.listen((speed) {
      _speed = speed;
      update();
    });
  }

  void _listenToVolume() {
    _audioHandler.volumeStream.listen((volume) {
      _volume = volume;
      update();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playerStateStream.listen((playerState) async {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        _playButtonState = PlayButtonState.loading;
      } else if (!isPlaying) {
        _playButtonState = PlayButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        _playButtonState = PlayButtonState.playing;
      } else {
        await _audioHandler.seek(Duration.zero);
        await _audioHandler.pause();
      }
      update();
    });
  }

  void _listenToPosition() {
    _audioHandler.positionDataStream.listen((positionData) {
      _progressBarState = ProgressBarState(
        current: positionData.position,
        buffered: positionData.bufferedPosition,
        total: positionData.duration,
      );
      update();
    });
  }

  Future<void> play() async => await _audioHandler.play();
  Future<void> pause() async => await _audioHandler.pause();

  Future<void> seek(Duration position) async =>
      await _audioHandler.seek(position);

  Future<void> previous() async => await _audioHandler.skipToPrevious();
  Future<void> next() async => await _audioHandler.skipToNext();

  Future<void> stop() async => await _audioHandler.stop();

  Future<void> toggleRepeatMode() async {
    // off -> playlist -> song ...
    switch (_repeatState) {
      case RepeatState.off:
        await _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
      case RepeatState.repeatSong:
        await _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      case RepeatState.repeatPlaylist:
        await _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    }
  }

  Future<void> toggleShuffle() async {
    await _audioHandler.setShuffleMode(_isShuffled
        ? AudioServiceShuffleMode.none
        : AudioServiceShuffleMode.all);
  }

  Future<void> toggleMute() async {
    if (!isMute) {
      _beforeMuteVolume = _volume;
      _isMute = true;
      await setVolume(0.0);
    } else {
      _isMute = false;
      await setVolume(_beforeMuteVolume);
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioHandler.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    _speed = double.parse(speed.toStringAsFixed(1));
    await _audioHandler.setSpeed(_speed);
  }

  @override
  Future<void> dispose() async {
    await _audioHandler.customAction('dispose');
    super.dispose();
  }
}
