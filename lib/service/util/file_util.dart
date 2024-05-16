import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:mulink/global/constant/const.dart';
import 'package:mulink/global/constant/value.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/util/generator_util.dart';
import 'package:mulink/service/util/parse_util.dart';

Future<Directory?> getDirectoryFromFilePicker() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  return selectedDirectory == null ? null : Directory(selectedDirectory);
}

Future<void> createDirectory(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
}

Future<List<Track>> getTracksFromDirectory({
  Directory? dir,
  bool isRecursive = false,
}) async {
  List<Track> tracks = [];
  if (dir != null) {
    await for (var entity
        in dir.list(recursive: isRecursive, followLinks: false)) {
      if (entity is File && isAudioFile(entity.path)) {
        tracks.add(await createTrackFromFile(entity));
      }
    }
  }
  return tracks;
}

Future<Track> createTrackFromFile(File file) async {
  final metadata = await MetadataRetriever.fromFile(file);

  String albumArtPath =
      await getAlbumArtPath(metadata.albumArt, getFileName(file.path));

  return Track(
    id: uuid.v4(),
    title: createTagData(metadata.trackName, getFileName(file.path)),
    artist: createTagData(metadata.trackArtistNames?.first, "<unknown artist>"),
    album: createTagData(metadata.albumName, "<unknown album>"),
    genre: createTagData(metadata.genre, "<unknown genre>"),
    artUri: Uri.file(albumArtPath),
    mediaType: MediaType.file,
    albumCover: metadata.albumArt,
    filePath: file.path,
    extras: {
      "filePath": file.path,
    },
  );
}

String createTagData(String? data, String alter) {
  return data == null || data.isEmpty ? alter : data;
}

Future<String> getAlbumArtPath(Uint8List? albumArt, String fileName) async {
  try {
    if (albumArt == null) {
      return "${AppPath.albumArtPath}/$basicAlbumArtFileName";
    }

    String filePath = "${AppPath.albumArtPath}/$fileName.png";
    File file = File(filePath);

    //TODO: need check logic if image file changed
    if (!await file.exists()) {
      await file.writeAsBytes(albumArt);
    }
    return file.path;
  } catch (err) {
    print(err);
    return "";
  }
}
