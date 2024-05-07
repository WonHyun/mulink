import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:mulink/test/playlist_mock.dart';

class PlaylistController extends GetxController {
  List<MediaItem>? _playlist;
  List<MediaItem>? get playlist => _playlist;

  MediaItem? _currentPlayTrack;
  MediaItem? get currentPlayTrack => _currentPlayTrack;

  final _audioHandler = getIt<CustomAudioHandler>();

  PlaylistController() {
    _playlist = playlistMock;
    _listenToChangesInSong();
  }

  void _listenToChangesInSong() {
    _audioHandler.queue.listen((value) {
      final queue = _audioHandler.queue.value;
      if (_playlist == null || _playlist != queue) {
        _playlist = queue;
        update();
      }
    });
    _audioHandler.mediaItem.listen((mediaItem) {
      final mediaItem = _audioHandler.mediaItem.value;
      if (_currentPlayTrack == null || _currentPlayTrack?.id != mediaItem?.id) {
        _currentPlayTrack = mediaItem;
        update();
      }
    });
  }

  void addPlaylist(MediaItem mediaItem) {
    _audioHandler.addQueueItem(mediaItem);
    update();
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
    update();
  }

  // Future<void> getAudioFilesFromDirectory() async {
  //   int index = 1;
  //   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //   if (selectedDirectory != null) {
  //     final dir = Directory(selectedDirectory);
  //     await for (var entity in dir.list(recursive: false, followLinks: false)) {
  //       if (entity is File && isAudioFile(entity.path)) {
  //         Track track = Track(
  //           id: index.toString().padLeft(5),
  //           title: getFileName(entity.path),
  //           mediaType: MediaType.file,
  //           extras: {
  //             "filePath": entity.path,
  //           },
  //         );
  //         addPlaylist(track);
  //         index++;
  //       }
  //     }
  //   }
  // }
}
