import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/notifiers/library_notifier.dart';
import 'package:mulink/providers/states/library_state.dart';

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, LibraryState>((ref) {
  return LibraryNotifier();
});
