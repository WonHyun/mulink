import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/global/extension/context_extension.dart';
import 'package:mulink/providers/providers.dart';

import '../component/play_state_button.dart';
import '../component/repeat_button.dart';
import '../component/shuffle_button.dart';

import 'dart:math' as math;

class PlayerControllPanel extends ConsumerWidget {
  const PlayerControllPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = math.min(context.deviceWidth / 12, 50.0);
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShuffleButton(
          isShuffled: playerState.isShuffled,
          onShuffle: playerNotifier.toggleShuffle,
          iconSize: iconSize * 0.7,
        ),
        const SizedBox(width: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: playerNotifier.previous,
              icon: Icon(
                FontAwesomeIcons.backwardStep,
                size: iconSize * 0.7,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: iconSize * 1.5,
              height: iconSize * 1.5,
              child: PlayStateButton(
                playButtonState: playerState.playButtonState,
                onPlay: playerNotifier.play,
                onPause: playerNotifier.pause,
                buttonSize: iconSize,
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: playerNotifier.next,
              icon: Icon(
                FontAwesomeIcons.forwardStep,
                size: iconSize * 0.7,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        LoopButton(
          loopState: playerState.loopState,
          onLoop: playerNotifier.toggleLoopMode,
          iconSize: iconSize * 0.7,
        ),
      ],
    );
  }
}
