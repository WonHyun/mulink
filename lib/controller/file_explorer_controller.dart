import 'dart:io';

import 'package:get/get.dart';
import 'package:mulink/service/util/file_util.dart';

class FileExplorerController extends GetxController {
  Directory? _currentDirectory;
  Directory? _root;

  Directory? get currentDirectory => _currentDirectory;
  Directory? get root => _root;

  Future<void> setRootPath() async {
    Directory? newRoot = await getDirectoryFromFilePicker();
    if (newRoot != null) {
      _root = newRoot;
      _currentDirectory = _root;
      update();
    }
  }

  void setCurrentDirectory(Directory newDir) {
    _currentDirectory = newDir;
    update();
  }

  void moveToParentDirectory() {
    try {
      if (_currentDirectory?.path != _root?.path) {
        _currentDirectory = _currentDirectory?.parent;
        update();
      }
    } catch (err) {
      print(err);
    }
  }
}
