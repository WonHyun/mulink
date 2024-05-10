import 'package:flutter/material.dart';
import 'package:mulink/controller/player_controller.dart';

import 'play_pause_button.dart';

class PlayStateButton extends StatelessWidget {
  const PlayStateButton({
    super.key,
    required this.playButtonState,
    required this.playCallback,
    required this.pauseCallback,
    required this.buttonSize,
  });

  final PlayButtonState playButtonState;
  final VoidCallback playCallback;
  final VoidCallback pauseCallback;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Builder(
        builder: (context) {
          switch (playButtonState) {
            case PlayButtonState.loading:
              return CircularProgressIndicator(color: Colors.cyan.shade300);
            case PlayButtonState.playing:
              return PlayPauseButton(
                callback: pauseCallback.call,
                iconData: Icons.pause,
                buttonSize: buttonSize,
              );
            case PlayButtonState.paused:
              return PlayPauseButton(
                callback: playCallback.call,
                iconData: Icons.play_arrow,
                buttonSize: buttonSize,
              );
            default:
              return PlayPauseButton(
                callback: playCallback.call,
                iconData: Icons.play_arrow_outlined,
                buttonSize: buttonSize,
              );
          }
        },
      ),
    );
  }
}
