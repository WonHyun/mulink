import 'package:flutter/material.dart';
import 'package:mulink/controller/player_controller.dart';

import 'play_pause_button.dart';

class PlayStateButton extends StatelessWidget {
  const PlayStateButton({
    super.key,
    required this.playButtonState,
    required this.playCallback,
    required this.pauseCallback,
    required this.iconSize,
  });

  final PlayButtonState playButtonState;
  final VoidCallback playCallback;
  final VoidCallback pauseCallback;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        switch (playButtonState) {
          case PlayButtonState.loading:
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(color: Colors.cyan.shade300),
            );
          case PlayButtonState.playing:
            return PlayPauseButton(
              callback: pauseCallback.call,
              iconData: Icons.pause,
              iconSize: iconSize,
            );
          case PlayButtonState.paused:
            return PlayPauseButton(
              callback: playCallback.call,
              iconData: Icons.play_arrow_outlined,
              iconSize: iconSize,
            );
          default:
            return PlayPauseButton(
              callback: playCallback.call,
              iconData: Icons.play_arrow_outlined,
              iconSize: iconSize,
            );
        }
      },
    );
  }
}
