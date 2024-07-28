import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/global/extension/context_extension.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/media_control_panel.dart';

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
        MediaControlPanel(iconSize: iconSize),
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
