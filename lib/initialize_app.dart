import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/library_controller.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/global/constant/const.dart';
import 'package:mulink/global/constant/value.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "secrets.env");

  await setupServiceLocator();

  Get.put(PlaylistController());
  Get.put(PlayerController());
  Get.put(LibraryController(playlistController: Get.find()));

  //TODO : Set Permission, Network, Preference, Auth ...
  if (!kIsWeb) {
    await AppPath.init();
    requestPermissions();
  }
  await savaBasicArtwork();
}

Future<void> requestPermissions() async {
  //TODO: implement seperate screen
  if (Platform.isAndroid || Platform.isIOS) {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }
}

Future<void> savaBasicArtwork() async {
  try {
    createDirectory(AppPath.albumArtPath);

    String filePath = "${AppPath.albumArtPath}/$basicAlbumArtFileName";

    //TODO: need check logic if image file changed
    File file = File(filePath);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(
        '$basicAlbumArtAssetPath/$basicAlbumArtFileName',
      );
      await file.writeAsBytes(
        byteData.buffer
            .asInt8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
  } catch (err) {
    print(err);
  }
}
