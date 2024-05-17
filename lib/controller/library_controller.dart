import 'dart:io';

import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/model/base/library_item.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/folder.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:mulink/service/util/parse_util.dart';

class LibraryController extends GetxController {
  Directory? _root;
  List<LibraryItem> _libraryItemList = [];
  Folder? _selectedFolder;
  Folder? _parentFolder;
  AudioFile? _selectedAudio;

  Directory? get root => _root;
  List<LibraryItem> get libraryItemList => _libraryItemList;
  Folder? get selectedFolder => _selectedFolder;
  Folder? get parentFolder => _parentFolder;
  AudioFile? get selectedAudio => _selectedAudio;

  PlaylistController playlistController;

  LibraryController({required this.playlistController});

  Future<void> setRootPath() async {
    Directory? newRoot = await getDirectoryFromFilePicker();
    if (newRoot != null) {
      _root = newRoot;
      _libraryItemList = [
        Folder(
          name: getFileName(_root!.path),
          path: _root!.path,
          children: await createLibraryItemList(_root!.path),
        ),
      ];
      _selectedFolder = _libraryItemList.first as Folder;
      _parentFolder = _selectedFolder;
      update();
    }
  }

  Future<List<LibraryItem>> createLibraryItemList(String currentPath) async {
    final dir = Directory(currentPath);
    final List<LibraryItem> items = [];

    await for (var entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is Directory) {
        final children = await createLibraryItemList(entity.path);
        items.add(
          Folder(
            name: getFileName(entity.path),
            path: entity.path,
            children: children,
          ),
        );
      }
      if (entity is File && isAudioFile(entity.path)) {
        final track = await createTrackFromFile(entity);
        items.add(
          AudioFile(
            name: getFileName(entity.path),
            path: entity.path,
            track: track,
          ),
        );
      }
    }
    return items;
  }

  void selectAudioFile(AudioFile selected) {
    if (selectedFolder != null) {
      playlistController.clearQueue();
      playlistController
          .addPlaylistItems(getTracksFromFolder(selectedFolder!.children));
      playlistController.setCurrentTrack(selected.track);
      _selectedAudio = selected;
    }
    update();
  }

  void selectFolder(Folder selected) {
    _parentFolder = _selectedFolder;
    _selectedFolder = selected;
    update();
  }

  void moveToParent() {
    _selectedFolder = _parentFolder;
    update();
  }

  List<Track> getTracksFromFolder(List<LibraryItem> itemList) {
    List<Track> tracks = [];
    for (var entity in itemList) {
      if (entity is AudioFile) {
        tracks.add(entity.track);
      }
    }
    return tracks;
  }
}
