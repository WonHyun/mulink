import 'package:mulink/model/base/library_item.dart';
import 'package:mulink/model/track.dart';

class AudioFile implements LibraryItem {
  @override
  final String name;

  @override
  final String path;

  @override
  bool get isDirectory => false;

  final Track track;

  const AudioFile({
    required this.name,
    required this.path,
    required this.track,
  });
}
