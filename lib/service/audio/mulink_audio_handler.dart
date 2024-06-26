import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mulink/model/position_data.dart';
import 'package:rxdart/rxdart.dart';

abstract class JustAudioHandler extends BaseAudioHandler {
  Stream<ProcessingState> get processingStateStream;
  Stream<SequenceState?> get sequenceStateStream;
  Stream<int?> get currentIndexStream;

  Stream<PlayerState> get playerStateStream;
  Stream<IcyMetadata?> get icyMetadataStream;
  Stream<PositionData> get positionDataStream;

  Stream<bool> get shuffleModeEnabledStream;
  Stream<List<int>?> get shuffleIndicesStream;
  Stream<LoopMode> get loopModeStream;

  Stream<double> get volumeStream;
  Stream<double> get speedStream;
  Stream<double> get pitchStream;

  Future<void> setVolume(double volume);
  Future<void> setPitch(double pitch);
  Future<void> clearQueue();
}

Future<JustAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MulinkAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.devwon.mulink.audio',
      androidNotificationChannelName: 'Mulink',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      preloadArtwork: true,
    ),
  );
}

class MulinkAudioHandler extends BaseAudioHandler implements JustAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  @override
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;
  @override
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  @override
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  @override
  Stream<IcyMetadata?> get icyMetadataStream => _player.icyMetadataStream;
  @override
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
                position: position,
                bufferedPosition: bufferedPosition,
                duration: duration ?? Duration.zero,
              ));

  @override
  Stream<bool> get shuffleModeEnabledStream => _player.shuffleModeEnabledStream;
  @override
  Stream<List<int>?> get shuffleIndicesStream => _player.shuffleIndicesStream;
  @override
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  @override
  Stream<double> get volumeStream => _player.volumeStream;
  @override
  Stream<double> get speedStream => _player.speedStream;
  @override
  Stream<double> get pitchStream => _player.pitchStream;

  MulinkAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    await _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    if (!queue.value.contains(mediaItem)) {
      // manage Just Audio
      final audioSource = _createAudioSource(mediaItem);
      await _playlist.add(audioSource);

      // notify system
      final newQueue = queue.value..add(mediaItem);
      queue.add(newQueue);
    }
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    if (mediaItem.extras?['filePath'] != null) {
      return AudioSource.file(
        mediaItem.extras?['filePath'],
        tag: mediaItem,
      );
    } else {
      return AudioSource.uri(
        Uri.parse(mediaItem.extras?['url'] as String),
        tag: mediaItem,
      );
    }
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    await _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  @override
  Future<void> seek(Duration position) async => await _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() async => await _player.seekToNext();

  @override
  Future<void> skipToPrevious() async => await _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      await _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _player.setPitch(pitch);
  }

  @override
  Future<void> clearQueue() async {
    // manage Just Audio
    await _playlist.clear();

    // notify system
    queue.value.clear();
  }
}
