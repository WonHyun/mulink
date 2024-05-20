import 'dart:io';

import 'package:mulink/model/audio_file.dart';
import 'package:mulink/model/base/library_item.dart';
import 'package:mulink/model/folder.dart';

class LibraryState {
  final Directory? root;
  final Folder? selectedFolder;
  final Folder? parentFolder;
  final AudioFile? selectedAudio;
  final List<LibraryItem> libraryItemList;

  LibraryState({
    this.root,
    this.selectedFolder,
    this.parentFolder,
    this.selectedAudio,
    this.libraryItemList = const [],
  });

  LibraryState copyWith({
    Directory? root,
    List<LibraryItem>? libraryItemList,
    Folder? selectedFolder,
    Folder? parentFolder,
    AudioFile? selectedAudio,
  }) {
    return LibraryState(
      root: root ?? this.root,
      libraryItemList: libraryItemList ?? this.libraryItemList,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      parentFolder: parentFolder ?? this.parentFolder,
      selectedAudio: selectedAudio ?? this.selectedAudio,
    );
  }
}
