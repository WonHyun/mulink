import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mulink/global/constant/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:mulink/service/util/generator_util.dart';
import 'package:mulink/service/util/parse_util.dart';

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

  String createTagData(String? data, String alter) {
    return data == null || data.isEmpty ? alter : data;
  }

  Future<String> getAlbumArtPath(Uint8List? albumArt, String fileName) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();

      if (albumArt == null) return "${appDir.path}/$basicArtworkFileName";

      String filePath = "${appDir.path}/$fileName.png";
      File file = File(filePath);

      //TODO: need check logic if image file changed
      if (!await file.exists()) {
        await file.writeAsBytes(albumArt);
      }
      return file.path;
    } catch (err) {
      print(err);
      return "";
    }
  }

  Future<Track> createTrackFromFile(File file) async {
    final metadata = await MetadataRetriever.fromFile(file);

    String albumArtPath =
        await getAlbumArtPath(metadata.albumArt, getFileName(file.path));

    return Track(
      id: uuid.v4(),
      title: createTagData(metadata.trackName, getFileName(file.path)),
      artist:
          createTagData(metadata.trackArtistNames?.first, "<unknown artist>"),
      album: createTagData(metadata.albumName, "<unknown album>"),
      genre: createTagData(metadata.genre, "<unknown genre>"),
      artUri: Uri.file(albumArtPath),
      mediaType: MediaType.file,
      albumCover: metadata.albumArt,
      filePath: file.path,
      extras: {
        "filePath": file.path,
      },
    );
  }

  Future<void> getAudioFilesFromDirectory() async {
    List<Track> tracks = [];
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final dir = Directory(selectedDirectory);
      await for (var entity in dir.list(recursive: false, followLinks: false)) {
        if (entity is File && isAudioFile(entity.path)) {
          tracks.add(await createTrackFromFile(entity));
        }
      }
    }
    addPlaylistItems(tracks);
  }
}
