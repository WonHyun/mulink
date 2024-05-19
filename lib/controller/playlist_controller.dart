import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/test/playlist_mock.dart';

class PlaylistController extends GetxController {
  final RxList<Track> _playlist = <Track>[].obs;
  List<Track> get playlist => _playlist;

  List<MediaItem> _oldPlaylist = [];

  final Rx<Track?> _currentPlayTrack = Rx<Track?>(null);
  Track? get currentPlayTrack => _currentPlayTrack.value;

  final JustAudioHandler audioHandler;

  PlaylistController({required this.audioHandler}) {
    _listenToChangesInSong();
    addPlaylistItems(playlistMock);
  }

  void _listenToChangesInSong() {
    audioHandler.queue.listen((queue) async {
      await setPlaylist(queue);
    });
    audioHandler.mediaItem.listen((mediaItem) async {
      await setCurrentTrack(
        _playlist.firstWhereOrNull(
          (element) => element.id == mediaItem?.id,
        ),
      );
    });
    audioHandler.sequenceStateStream.listen((sequenceState) {});
  }

  Future<void> setPlaylist(List<MediaItem> newPlaylist) async {
    if (_oldPlaylist != newPlaylist) {
      _oldPlaylist = newPlaylist;
      _playlist.value = _oldPlaylist.whereType<Track>().toList();
      update();
    }
  }

  Future<void> setCurrentTrack(Track? track) async {
    if (track != null && track.id != _currentPlayTrack.value?.id) {
      _currentPlayTrack.value = track;
      await audioHandler.skipToQueueItem(_playlist.indexOf(track));
      update();
    }
  }

  Future<void> addPlaylistItem(Track track) async {
    if (!_playlist.contains(track)) {
      _playlist.add(track);
      await audioHandler.addQueueItem(track);
    }
  }

  Future<void> addPlaylistItems(List<Track> tracks) async {
    _playlist.addAll(tracks);
    await audioHandler.addQueueItems(tracks);
  }

  Future<void> remove() async {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    await audioHandler.removeQueueItemAt(lastIndex);
  }

  Future<void> clearQueue() async {
    _playlist.clear();
    _currentPlayTrack.value = null;
    await audioHandler.clearQueue();
  }
}
