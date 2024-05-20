import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/global/type/stack.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/base/library_item.dart';
import 'package:mulink/model/folder.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/providers/states/library_state.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:mulink/service/util/parse_util.dart';

class LibraryNotifier extends StateNotifier<LibraryState> {
  //TODO: should be change from getx to riverpod
  final PlaylistController playlistController = Get.find();

  late final StreamSubscription<Track?> _subscription;

  final Map<Track, AudioFile> _audioFileMap = {};

  LibraryNotifier() : super(LibraryState()) {
    _subscription =
        playlistController.currentPlayTrackStream.listen(updateSelectedAudio);
  }

  void updateSelectedAudio(Track? track) {
    if (track != null) {
      state = state.copyWith(selectedAudio: _audioFileMap[track]);
    }
  }

  void updateRoot(Directory directory) {
    state = state.copyWith(root: directory);
  }

  void updateLibraryItems(List<LibraryItem> items) {
    state = state.copyWith(libraryItemList: items);
  }

  void updateSelectedFolder(Folder? selected, Folder? parent) {
    state = state.copyWith(selectedFolder: selected, parentFolder: parent);
  }

  Future<void> setRootPath() async {
    Directory? newRoot = await getDirectoryFromFilePicker();
    if (newRoot != null) {
      updateRoot(newRoot);
      final libraryItemList = [
        Folder(
          name: getFileName(state.root!.path),
          path: state.root!.path,
          children: await createLibraryItemList(state.root!.path),
        ),
      ];
      updateSelectedFolder(libraryItemList.first, libraryItemList.first);
      await playlistController
          .addPlaylistItems(getTracksFromAllFolder(state.selectedFolder!));
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
        final audioFile = AudioFile(
          name: getFileName(entity.path),
          path: entity.path,
          track: track,
        );
        _audioFileMap[audioFile.track] = audioFile;
        items.add(audioFile);
      }
    }
    return items;
  }

  Future<void> selectAudioFile(AudioFile selected) async {
    await playlistController.setCurrentTrack(selected.track);
  }

  void selectFolder(Folder selected) {
    updateSelectedFolder(selected, state.selectedFolder);
  }

  void moveToParent() {
    updateSelectedFolder(state.parentFolder, state.parentFolder);
  }

  List<Track> getTracksFromFolder(List<LibraryItem> children) {
    List<Track> tracks = [];
    for (var entity in children) {
      if (entity is AudioFile) {
        tracks.add(entity.track);
      }
    }
    return tracks;
  }

  List<Track> getTracksFromAllFolder(Folder root) {
    List<Track> tracks = [];
    Stack<Folder> stack = Stack<Folder>();

    stack.push(root);

    while (!stack.isEmpty) {
      Folder currentFolder = stack.pop();

      for (var entity in currentFolder.children) {
        if (entity is Folder) {
          stack.push(entity);
        }
        if (entity is AudioFile) {
          tracks.add(entity.track);
        }
      }
    }

    return tracks;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
