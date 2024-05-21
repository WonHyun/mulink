import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/component/play_state_button.dart';

class MiniPlayerControllPanel extends ConsumerWidget {
  const MiniPlayerControllPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.watch(playerProvider.notifier);
    return Row(
      children: [
        IconButton(
          onPressed: playerNotifier.previous,
          icon: const Icon(Icons.skip_previous),
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        PlayStateButton(
          playButtonState: playerState.playButtonState,
          onPlay: playerNotifier.play,
          onPause: playerNotifier.pause,
          buttonSize: 40,
        ),
        IconButton(
          onPressed: playerNotifier.next,
          icon: const Icon(Icons.skip_next),
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ],
    );
  }
}
