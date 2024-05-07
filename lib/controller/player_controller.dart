import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
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

  final PlaylistController playlistController;

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

  PlayerController(this.playlistController) {
    init();
  }

  void init() async {
    await _loadPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToTotalDuration();
    _listenToBufferedPosition();
  }

  Future<void> _loadPlaylist() async {
    _audioHandler.addQueueItems(playlistController.playlist as List<MediaItem>);
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        _playButtonState = PlayButtonState.loading;
      } else if (!isPlaying) {
        _playButtonState = PlayButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        _playButtonState = PlayButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      update();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = _progressBarState;
      _progressBarState = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      update();
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = _progressBarState;
      _progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
      update();
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = _progressBarState;
      _progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
      update();
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void stop() => _audioHandler.stop();

  void toggleRepeatMode() {
    // off -> playlist -> song ...
    switch (_repeatState) {
      case RepeatState.off:
        _repeatState = RepeatState.repeatPlaylist;
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
      case RepeatState.repeatSong:
        _repeatState = RepeatState.off;
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatPlaylist:
        _repeatState = RepeatState.repeatSong;
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
    }
    update();
  }

  void toggleShuffle() {
    _audioHandler.setShuffleMode(_isShuffled
        ? AudioServiceShuffleMode.none
        : AudioServiceShuffleMode.all);
    _isShuffled = !_isShuffled;
    update();
  }

  void toggleMute() {
    if (!isMute) {
      _beforeMuteVolume = _volume;
      _isMute = true;
      setVolume(0.0);
    } else {
      _isMute = false;
      setVolume(_beforeMuteVolume);
    }
  }

  void setVolume(double volume) {
    _volume = volume;
    _audioHandler.setVolume(volume);
    update();
  }

  void setSpeed(double speed) {
    _speed = double.parse(speed.toStringAsFixed(1));
    _audioHandler.setSpeed(_speed);
    update();
  }

  @override
  void dispose() {
    _audioHandler.customAction('dispose');
    super.dispose();
  }
}
