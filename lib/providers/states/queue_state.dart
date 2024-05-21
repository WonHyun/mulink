import 'package:mulink/model/track.dart';

class QueueState {
  final List<Track> queue;
  final Track? currentTrack;

  QueueState({
    this.queue = const [],
    this.currentTrack,
  });

  QueueState copyWith({
    List<Track>? queue,
    Track? currentTrack,
  }) {
    return QueueState(
      queue: queue ?? this.queue,
      currentTrack: currentTrack ?? this.currentTrack,
    );
  }
}
