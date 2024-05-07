import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/service/service_rocator.dart';

Future<void> initializeApp() async {
  await setupServiceLocator();
  Get.put(PlaylistController());
  Get.put(PlayerController(Get.find()));
  //TODO : Set Permission, Network, Preference, Auth ...
  if (kIsWeb) {
    //TODO : Web platform init
  }
}
