import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';

class AudioProgressBar extends ConsumerWidget {
  const AudioProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProgressBar(
        progress: playerState.positionState.position,
        buffered: playerState.positionState.bufferedPosition,
        total: playerState.positionState.duration,
        onSeek: playerNotifier.seek,
        barHeight: 10,
        progressBarColor: Theme.of(context).colorScheme.inverseSurface,
        thumbColor: Theme.of(context).colorScheme.inverseSurface,
        baseBarColor:
            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4),
      ),
    );
  }
}
