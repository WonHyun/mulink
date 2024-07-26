import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final iconSize = math.min(context.deviceWidth / 12, 50.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShuffleButton(
          isShuffled: state.isShuffled,
          onShuffle: notifier.toggleShuffle,
          iconSize: iconSize * 0.8,
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: notifier.previous,
          icon: FaIcon(
            FontAwesomeIcons.backwardStep,
            size: iconSize * 0.8,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(width: 10),
        PlayStateButton(
          playButtonState: state.playButtonState,
          onPlay: notifier.play,
          onPause: notifier.pause,
          buttonSize: iconSize * 1.5,
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: notifier.next,
          icon: FaIcon(
            FontAwesomeIcons.forwardStep,
            size: iconSize * 0.8,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(width: 10),
        LoopButton(
          loopState: state.loopState,
          onLoop: notifier.toggleLoopMode,
          iconSize: iconSize * 0.8,
        ),
      ],
    );
  }
}
