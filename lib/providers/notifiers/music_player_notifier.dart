import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mulink/model/position_data.dart';
import 'package:mulink/providers/states/music_player_state.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:audio_service/audio_service.dart';

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  final JustAudioHandler audioHandler;
  double _beforeMuteVolume = 0.8;

  MusicPlayerNotifier({required this.audioHandler})
      : super(MusicPlayerState()) {
    _listenToPlaybackState();
    _listenToPosition();
    _listenToVolume();
    _listenToSpeed();
    _listenToLoopMode();
    _listenToShuffleMode();
  }

  void updateVolume(double volume) {
    state = state.copyWith(volume: volume);
  }

  void updateSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  void updatePitch(double pitch) {
    state = state.copyWith(pitch: pitch);
  }

  void updateMute(bool isMute) {
    state = state.copyWith(isMute: isMute);
  }

  void updateShuffleMode(bool isShuffled) {
    state = state.copyWith(isShuffled: isShuffled);
  }

  void updateLoopMode(LoopState loopState) {
    state = state.copyWith(loopState: loopState);
  }

  void updatePlayButton(PlayButtonState playButtonState) {
    state = state.copyWith(playButtonState: playButtonState);
  }

  void updatePosition(PositionData positionState) {
    state = state.copyWith(positionState: positionState);
  }

  void _listenToShuffleMode() {
    audioHandler.shuffleModeEnabledStream.listen((isShuffled) {
      updateShuffleMode(isShuffled);
    });
  }

  void _listenToLoopMode() {
    audioHandler.loopModeStream.listen((loopMode) {
      switch (loopMode) {
        case LoopMode.off:
          updateLoopMode(LoopState.off);
        case LoopMode.all:
          updateLoopMode(LoopState.loopAll);
        case LoopMode.one:
          updateLoopMode(LoopState.loopOne);
        default:
          updateLoopMode(LoopState.off);
      }
    });
  }

  void _listenToSpeed() {
    audioHandler.speedStream.listen((speed) {
      updateSpeed(speed);
    });
  }

  void _listenToVolume() {
    audioHandler.volumeStream.listen((volume) {
      updateVolume(volume);
    });
  }

  void _listenToPlaybackState() {
    audioHandler.playerStateStream.listen((playerState) async {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        updatePlayButton(PlayButtonState.loading);
      } else if (!isPlaying) {
        updatePlayButton(PlayButtonState.paused);
      } else if (processingState != ProcessingState.completed) {
        updatePlayButton(PlayButtonState.playing);
      } else {
        await audioHandler.seek(Duration.zero);
        await audioHandler.pause();
      }
    });
  }

  void _listenToPosition() {
    audioHandler.positionDataStream.listen((positionData) {
      updatePosition(positionData);
    });
  }

  Future<void> play() async => await audioHandler.play();
  Future<void> pause() async => await audioHandler.pause();

  Future<void> seek(Duration position) async =>
      await audioHandler.seek(position);

  Future<void> previous() async => await audioHandler.skipToPrevious();
  Future<void> next() async => await audioHandler.skipToNext();

  Future<void> stop() async => await audioHandler.stop();

  Future<void> toggleLoopMode() async {
    // off -> playlist -> song ...
    switch (state.loopState) {
      case LoopState.off:
        await audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
      case LoopState.loopAll:
        await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      case LoopState.loopOne:
        await audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    }
  }

  Future<void> toggleShuffle() async {
    await audioHandler.setShuffleMode(state.isShuffled
        ? AudioServiceShuffleMode.none
        : AudioServiceShuffleMode.all);
  }

  Future<void> toggleMute() async {
    if (!state.isMute) {
      _beforeMuteVolume = state.volume;
      updateMute(true);
      await setVolume(0.0);
    } else {
      updateMute(false);
      await setVolume(_beforeMuteVolume);
    }
  }

  Future<void> setVolume(double volume) async {
    await audioHandler.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await audioHandler.setSpeed(double.parse(speed.toStringAsFixed(1)));
  }

  Future<void> setPitch(double pitch) async {
    await audioHandler.setPitch(double.parse(pitch.toStringAsFixed(1)));
  }

  @override
  Future<void> dispose() async {
    await audioHandler.customAction('dispose');
    super.dispose();
  }
}
