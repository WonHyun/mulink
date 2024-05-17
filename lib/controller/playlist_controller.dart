import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';
// import 'package:mulink/test/playlist_mock.dart';

class PlaylistController extends GetxController {
  List<Track> _playlist = [];
  List<Track> get playlist => _playlist;

  List<MediaItem> _oldPlaylist = [];

  Track? _currentPlayTrack;
  Track? get currentPlayTrack => _currentPlayTrack;

  final _audioHandler = getIt<CustomAudioHandler>();

  PlaylistController() {
    // _playlist = playlistMock;
    _listenToChangesInSong();
  }

  void _listenToChangesInSong() {
    _audioHandler.queue.listen((queue) {
      setPlaylist(queue);
    });
    _audioHandler.mediaItem.listen((mediaItem) {
      setCurrentTrack(
        _playlist.firstWhereOrNull(
          (element) => element.id == mediaItem?.id,
        ),
      );
    });
  }

  Future<void> setPlaylist(List<MediaItem> newPlaylist) async {
    if (_oldPlaylist != newPlaylist) {
      _oldPlaylist = newPlaylist;
      _playlist = _oldPlaylist.whereType<Track>().toList();
      update();
    }
  }

  Future<void> setCurrentTrack(Track? track) async {
    if (track != null && track.id != _currentPlayTrack?.id) {
      _currentPlayTrack = track;
      await _audioHandler.skipToQueueItem(_playlist.indexOf(track));
      update();
    }
  }

  Future<void> addPlaylistItem(Track track) async {
    if (!_playlist.contains(track)) {
      _playlist.add(track);
      await _audioHandler.addQueueItem(track);
      update();
    }
  }

  Future<void> addPlaylistItems(List<Track> tracks) async {
    _playlist.addAll(tracks);
    await _audioHandler.addQueueItems(tracks);
    update();
  }

  Future<void> remove() async {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    await _audioHandler.removeQueueItemAt(lastIndex);
    update();
  }

  Future<void> clearQueue() async {
    _playlist.clear();
    _currentPlayTrack = null;
    await _audioHandler.clearQueue();
    update();
  }
}
