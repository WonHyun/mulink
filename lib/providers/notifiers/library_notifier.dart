import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/global/type/stack.dart';
import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/base/library_item.dart';
import 'package:mulink/model/folder.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/providers/notifiers/queue_notifier.dart';
import 'package:mulink/providers/states/library_state.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:mulink/service/util/parse_util.dart';
import 'package:mulink/service/util/setting_util.dart';

class LibraryNotifier extends StateNotifier<LibraryState> {
  final QueueNotifier queueNotifier;
  late final StreamSubscription<Track?> _trackStreamSubscription;

  final Map<Track, AudioFile> _audioFileMap = {};

  LibraryNotifier({required this.queueNotifier}) : super(LibraryState()) {
    _trackStreamSubscription =
        queueNotifier.currentTrackStream.listen(updateSelectedAudio);
    loadSettingRootPath();
  }

  Future<void> loadSettingRootPath() async {
    try {
      final path = await loadRootPathSetting();
      if (path != "") {
        await setRootPath(Directory(path));
      }
    } catch (err) {
      print(err);
    }
  }

  void updateSelectedAudio(Track? track) {
    if (track != null) {
      state = state.copyWith(selectedAudio: _audioFileMap[track]);
    }
  }

  void updateRoot(Directory directory) {
    state = state.copyWith(root: directory);
    saveRootPathSetting(directory.path);
  }

  void updateLibraryItems(List<LibraryItem> items) {
    state = state.copyWith(libraryItemList: items);
  }

  void updateSelectedFolder(Folder? selected, Folder? parent) {
    state = state.copyWith(selectedFolder: selected, parentFolder: parent);
  }

  Future<void> setRootPath(Directory root) async {
    updateRoot(root);
    final libraryItemList = [
      Folder(
        name: getFileName(state.root!.path),
        path: state.root!.path,
        children: await createLibraryItemList(state.root!.path),
      ),
    ];
    updateSelectedFolder(libraryItemList.first, libraryItemList.first);
    await queueNotifier
        .addPlaylistItems(await getTracksFromAllFolder(state.selectedFolder!));
  }

  Future<void> setPathFromFilePicker() async {
    Directory? newRoot = await getDirectoryFromFilePicker();
    if (newRoot != null) {
      setRootPath(newRoot);
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
    await queueNotifier.setCurrentTrack(selected.track);
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
