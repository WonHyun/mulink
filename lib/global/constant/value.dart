import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppPath {
  static late final Directory appDocumentsDir;
  static late final String albumArtPath;

  static Future<void> init() async {
    appDocumentsDir = await getApplicationDocumentsDirectory();
    albumArtPath = "${appDocumentsDir.path}/albumArt";
  }
}
