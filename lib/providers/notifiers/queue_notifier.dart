import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/global/extension/type_extension.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/providers/states/queue_state.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/util/image_util.dart';
// import 'package:mulink/test/playlist_mock.dart';

class QueueNotifier extends StateNotifier<QueueState> {
  final JustAudioHandler audioHandler;

  final _currentTrackController = StreamController<Track?>.broadcast();
  Stream<Track?> get currentTrackStream => _currentTrackController.stream;

  int get currentTrackIndex =>
      state.currentTrack != null ? state.queue.indexOf(state.currentTrack!) : 0;

  List<MediaItem> _oldPlaylist = [];

  QueueNotifier({required this.audioHandler}) : super(QueueState()) {
    _listenToChangesInSong();
    // addPlaylistItems(playlistMock);
  }

  void _listenToChangesInSong() {
    audioHandler.queue.listen((queue) async {
      if (_oldPlaylist != queue) {
        _oldPlaylist = queue;
        updateQueue(_oldPlaylist.whereType<Track>().toList());
      }
    });
    audioHandler.mediaItem.listen((mediaItem) async {
      await setCurrentTrack(
        state.queue.firstWhereOrNull(
          (element) => element.id == mediaItem?.id,
        ),
      );
    });
    currentTrackStream.listen((track) {
      if (track != null && track.albumCover != null) {
        state = state.copyWith(
          trackColor: calculateAverageColor(imageData: track.albumCover),
        );
      } else {
        state = state.copyWith(trackColor: Colors.indigo);
      }
    });
  }

  void updateQueue(List<Track> queue) {
    state = state.copyWith(queue: queue);
  }

  void updateQueueFromTracks(List<Track> tracks) {
    state = state.copyWith(queue: [...state.queue, ...tracks]);
  }

  void updateCurrentTrack(Track? track) {
    state = state.copyWith(currentTrack: track);
    _currentTrackController.add(track);
  }

  Future<void> setCurrentTrack(Track? track) async {
    updateCurrentTrack(track);
    if (track != null) {
      await audioHandler.skipToQueueItem(state.queue.indexOf(track));
    }
  }

  Future<void> addPlaylistItem(Track track) async {
    await audioHandler.addQueueItem(track);
  }

  Future<void> addPlaylistItems(List<Track> tracks) async {
    await audioHandler.addQueueItems(tracks);
  }

  Future<void> remove() async {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    await audioHandler.removeQueueItemAt(lastIndex);
  }

  Future<void> clearQueue() async {
    updateQueue([]);
    updateCurrentTrack(null);
    await audioHandler.clearQueue();
  }
}
