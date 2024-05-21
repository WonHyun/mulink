import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/notifiers/library_notifier.dart';
import 'package:mulink/providers/notifiers/music_player_notifier.dart';
import 'package:mulink/providers/notifiers/queue_notifier.dart';
import 'package:mulink/providers/states/library_state.dart';
import 'package:mulink/providers/states/music_player_state.dart';
import 'package:mulink/providers/states/queue_state.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';
import 'package:mulink/service/service_rocator.dart';

final audioHandlerProvider = Provider<JustAudioHandler>((ref) {
  return getIt<JustAudioHandler>();
});

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, LibraryState>((ref) {
  final queueNotifier = ref.watch(queueProvider.notifier);
  return LibraryNotifier(queueNotifier: queueNotifier);
});

final playerProvider =
    StateNotifierProvider<MusicPlayerNotifier, MusicPlayerState>((ref) {
  final audioHandler = ref.watch(audioHandlerProvider);
  return MusicPlayerNotifier(audioHandler: audioHandler);
});

final queueProvider = StateNotifierProvider<QueueNotifier, QueueState>((ref) {
  final audioHandler = ref.watch(audioHandlerProvider);
  return QueueNotifier(audioHandler: audioHandler);
});
