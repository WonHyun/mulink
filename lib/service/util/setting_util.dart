import 'package:hive_flutter/hive_flutter.dart';

Future<void> saveRootPathSetting(String rootPath) async {
  var box = await Hive.openBox("paths");
  await box.put("root", rootPath);
}

Future<String> loadRootPathSetting() async {
  var box = await Hive.openBox("paths");
  String path = box.get("root", defaultValue: "");
  return path;
}
