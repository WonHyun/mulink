import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/library_controller.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/global/constant/value.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set up .env files
  await dotenv.load(fileName: "secrets.env");

  await initializeController();

  //TODO : Set Permission, Network, Preference, Auth ...
  if (!kIsWeb) {
    await requestPermissions();
    await AppPath.init();
    await savaBasicArtwork();
  }
}

Future<void> initializeController() async {
  final audioHandler = await initAudioService();

  // Dependency Injection
  Get.put(PlaylistController(audioHandler: audioHandler));
  Get.put(PlayerController(audioHandler: audioHandler));
  Get.put(LibraryController(playlistController: Get.find()));
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
