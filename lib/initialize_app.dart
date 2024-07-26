import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mulink/global/constant/value.dart';
import 'package:mulink/service/service_rocator.dart';
import 'package:mulink/service/util/file_util.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set up .env files
  await dotenv.load(fileName: "secrets.env");

  await Hive.initFlutter();

  await setupServiceLocator();

  //TODO : Set Permission, Network, Preference, Auth ...
  if (!kIsWeb) {
    await requestPermissions();
    await AppPath.init();
    await savaBasicArtwork();
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
