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

  late final StreamSubscription<Track?> _trackStreamSubscription;

  final Map<Track, AudioFile> _audioFileMap = {};

  LibraryNotifier() : super(LibraryState()) {
    _trackStreamSubscription =
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
      await playlistController.addPlaylistItems(
          await getTracksFromAllFolder(state.selectedFolder!));
    }
  }

  Future<List<LibraryItem>> createLibraryItemList(String currentPath) async {
    final dir = Directory(currentPath);
    final entities =
        await dir.list(recursive: false, followLinks: false).toList();
    var items = await Future.wait(
        entities.map((entity) async => await _toLibraryItem(entity)));
    return items.whereType<LibraryItem>().toList();
  }

  Future<LibraryItem?> _toLibraryItem(FileSystemEntity entity) async {
    if (entity is Directory) {
      return Folder(
          name: getFileName(entity.path),
          path: entity.path,
          children: await createLibraryItemList(entity.path));
    } else if (entity is File && isAudioFile(entity.path)) {
      return registerAudioFileMap(
        AudioFile(
          name: getFileName(entity.path),
          path: entity.path,
          track: await createTrackFromFile(entity),
        ),
      );
    }
    return null;
  }

  AudioFile registerAudioFileMap(AudioFile file) {
    _audioFileMap[file.track] = file;
    return file;
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
    return children
        .whereType<AudioFile>()
        .map((audioFile) => (audioFile).track)
        .toList();
  }

  Future<List<Track>> getTracksFromAllFolder(Folder root) async {
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
    _trackStreamSubscription.cancel();
    super.dispose();
  }
}
