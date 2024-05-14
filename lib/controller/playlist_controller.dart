import 'package:audio_service/audio_service.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:get/get.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';

class PlaylistController extends GetxController {
  List<Track> _playlist = [];
  List<Track> get playlist => _playlist;

  List<MediaItem> _oldPlaylist = [];

  Track? _currentPlayTrack;
  Track? get currentPlayTrack => _currentPlayTrack;

  final _audioHandler = getIt<CustomAudioHandler>();

  PlaylistController() {
    _listenToChangesInSong();
  }

  void _listenToChangesInSong() {
    _audioHandler.queue.listen((queue) {
      if (_oldPlaylist != queue) {
        _oldPlaylist = queue;
        _playlist = _oldPlaylist.whereType<Track>().toList();
        update();
      }
      if (_playlist.isNotEmpty && _currentPlayTrack == null) {
        _currentPlayTrack = _playlist.first;
      }
    });
    _audioHandler.mediaItem.listen((mediaItem) {
      if (_playlist.isNotEmpty) {
        if (_currentPlayTrack == null ||
            _currentPlayTrack?.id != mediaItem?.id) {
          _currentPlayTrack =
              _playlist.singleWhere((element) => element.id == mediaItem?.id);
          update();
        }
      }
    });
  }

  void setCurrentTrack(Track? track) {
    if (track != null) {
      _audioHandler.skipToQueueItem(_playlist.indexOf(track));
    }
  }

  void addPlaylistItem(Track track) {
    _audioHandler.addQueueItem(track);
  }

  void addPlaylistItems(List<Track> tracks) {
    _audioHandler.addQueueItems(tracks);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  Future<void> getAudioFilesFromDirectory() async {
    addPlaylistItems(await getTracksFromDirectory());
  }
}
