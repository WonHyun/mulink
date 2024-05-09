import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeApp() async {
  await setupServiceLocator();
  Get.put(PlaylistController());
  Get.put(PlayerController(Get.find()));
  //TODO : Set Permission, Network, Preference, Auth ...
  if (!kIsWeb) {
    requestPermissions();
  }
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
