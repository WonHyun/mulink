import 'package:audio_service/audio_service.dart';

enum MediaType {
  file,
  url,
}

class Track extends MediaItem {
  bool isFavorite;
  MediaType mediaType;
  String? albumArtPath;
  String? filePath;

  Track({
    required super.id,
    required super.title,
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
    this.mediaType = MediaType.file,
    this.albumArtPath,
  });

  factory Track.fromMediaItem(MediaItem mediaItem) {
    return Track(
      id: mediaItem.id,
      title: mediaItem.title,
      album: mediaItem.album,
      artist: mediaItem.artist,
      genre: mediaItem.genre,
      duration: mediaItem.duration,
      artUri: mediaItem.artUri,
      artHeaders: mediaItem.artHeaders,
      playable: mediaItem.playable,
      displayTitle: mediaItem.displayTitle,
      displaySubtitle: mediaItem.displaySubtitle,
      displayDescription: mediaItem.displayDescription,
      rating: mediaItem.rating,
      extras: mediaItem.extras,
    );
  }

  //TODO : save setting value (volume, speed...)
}
