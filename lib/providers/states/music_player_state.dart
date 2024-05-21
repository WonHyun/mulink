import 'package:mulink/model/position_data.dart';

enum PlayButtonState {
  paused,
  playing,
  loading,
}

enum LoopState {
  off,
  loopOne,
  loopAll;
}

class MusicPlayerState {
  final double volume;
  final double speed;
  final double pitch;
  final bool isMute;

  final bool isShuffled;
  final LoopState loopState;
  final PlayButtonState playButtonState;
  final PositionData positionState;

  MusicPlayerState({
    this.volume = 0.8,
    this.speed = 1.0,
    this.pitch = 1.0,
    this.isMute = false,
    this.isShuffled = false,
    this.loopState = LoopState.off,
    this.playButtonState = PlayButtonState.paused,
    this.positionState = const PositionData(
      position: Duration.zero,
      bufferedPosition: Duration.zero,
      duration: Duration.zero,
    ),
  });

  MusicPlayerState copyWith({
    double? volume,
    double? speed,
    double? pitch,
    bool? isMute,
    bool? isShuffled,
    LoopState? loopState,
    PlayButtonState? playButtonState,
    PositionData? positionState,
  }) {
    return MusicPlayerState(
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      isMute: isMute ?? this.isMute,
      isShuffled: isShuffled ?? this.isShuffled,
      loopState: loopState ?? this.loopState,
      playButtonState: playButtonState ?? this.playButtonState,
      positionState: positionState ?? this.positionState,
    );
  }
}
