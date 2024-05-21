import 'package:flutter/material.dart';
import 'package:mulink/global/extension/context_extension.dart';
import 'package:mulink/providers/notifiers/music_player_notifier.dart';
import 'package:mulink/providers/states/music_player_state.dart';

import '../component/play_state_button.dart';
import '../component/repeat_button.dart';
import '../component/shuffle_button.dart';

import 'dart:math' as math;

class PlayerControllPanel extends StatelessWidget {
  const PlayerControllPanel({
    super.key,
    required this.state,
    required this.notifier,
  });

  final MusicPlayerState state;
  final MusicPlayerNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final iconSize = math.min(context.deviceWidth / 10, 50.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShuffleButton(
          isShuffled: state.isShuffled,
          onShuffle: notifier.toggleShuffle,
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: notifier.previous,
          icon: Icon(
            Icons.skip_previous,
            size: iconSize,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PlayStateButton(
            playButtonState: state.playButtonState,
            onPlay: notifier.play,
            onPause: notifier.pause,
            buttonSize: iconSize * 1.5,
          ),
        ),
        IconButton(
          onPressed: notifier.next,
          icon: Icon(
            Icons.skip_next,
            size: iconSize,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        LoopButton(
          loopState: state.loopState,
          onLoop: notifier.toggleLoopMode,
          iconSize: iconSize,
        ),
      ],
    );
  }
}
