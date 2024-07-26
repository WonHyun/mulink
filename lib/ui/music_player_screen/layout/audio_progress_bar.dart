import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:mulink/model/position_data.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    required this.position,
    required this.onSeek,
  });

  final PositionData position;
  final Function(Duration) onSeek;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProgressBar(
        progress: position.position,
        buffered: position.bufferedPosition,
        total: position.duration,
        onSeek: onSeek,
        barHeight: 10,
        progressBarColor: Theme.of(context).colorScheme.inverseSurface,
        thumbColor: Theme.of(context).colorScheme.inverseSurface,
        baseBarColor:
            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4),
      ),
    );
  }
}
