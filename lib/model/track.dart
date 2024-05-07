import 'package:audio_service/audio_service.dart';

enum MediaType {
  file,
  url,
}

class Track extends MediaItem {
  Track({
    required super.id,
    required super.title,
    required this.mediaType,
    super.album,
    super.artist,
    super.genre,
    super.duration,
    super.artUri,
    super.artHeaders,
    super.playable = true,
    super.displayTitle,
    super.displaySubtitle,
    super.displayDescription,
    super.rating,
    super.extras,
    this.isFavorite = false,
    this.albumArtPath,
  });
  bool isFavorite;
  String? albumArtPath;
  String? filePath;
  MediaType mediaType;

  //TODO : save setting value (volume, speed...)
}
