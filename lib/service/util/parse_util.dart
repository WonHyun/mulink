import 'package:path/path.dart' as p;

bool isAudioFile(String filePath) {
  const audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];
  String extension = filePath.split('.').last.toLowerCase();
  return audioExtensions.contains('.$extension');
}

String getFileName(String path) {
  return p.basenameWithoutExtension(path);
}

String getFileExtension(String path) {
  return p.extension(path);
}
