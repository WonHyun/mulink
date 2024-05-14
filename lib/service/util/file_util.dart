import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:mulink/global/constant/const.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/service/util/generator_util.dart';
import 'package:mulink/service/util/parse_util.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Track>> getTracksFromDirectory() async {
  List<Track> tracks = [];
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    final dir = Directory(selectedDirectory);
    await for (var entity in dir.list(recursive: false, followLinks: false)) {
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
    Directory appDir = await getApplicationDocumentsDirectory();

    if (albumArt == null) return "${appDir.path}/$basicArtworkFileName";

    String filePath = "${appDir.path}/$fileName.png";
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
