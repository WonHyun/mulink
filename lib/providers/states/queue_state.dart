import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';

class QueueState {
  final List<Track> queue;
  final Track? currentTrack;
  final Color? trackColor;

  QueueState({
    this.queue = const [],
    this.currentTrack,
    this.trackColor,
  });

  QueueState copyWith({
    List<Track>? queue,
    Track? currentTrack,
    Color? trackColor,
  }) {
    return QueueState(
      queue: queue ?? this.queue,
      currentTrack: currentTrack ?? this.currentTrack,
      trackColor: trackColor ?? this.trackColor,
    );
  }
}
