import 'dart:io';

import 'package:get/get.dart';
import 'package:mulink/service/util/file_util.dart';

class FileExplorerController extends GetxController {
  Directory? _currentDirectory;
  Directory? _root;

  Directory? get currentDirectory => _currentDirectory;
  Directory? get root => _root;

  Future<void> setRootPath() async {
    _root = await getDirectoryFromFilePicker();
    _currentDirectory = _root;
    update();
  }

  void setCurrentDirectory(Directory newDir) {
    _currentDirectory = newDir;
    update();
  }

  void moveToParentDirectory() {
    try {
      if (_currentDirectory != _root) {
        _currentDirectory = _currentDirectory?.parent;
        update();
      }
    } catch (err) {
      print(err);
    }
  }
}
