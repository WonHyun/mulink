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
}
