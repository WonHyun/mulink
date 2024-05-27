import 'package:mulink/model/base/library_item.dart';

class Folder implements LibraryItem {
  @override
  final String name;

  @override
  final String path;

  @override
  bool get isDirectory => true;

  final List<LibraryItem> children;

  const Folder({
    required this.name,
    required this.path,
    required this.children,
  });
}
