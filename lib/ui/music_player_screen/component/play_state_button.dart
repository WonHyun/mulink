import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/states/music_player_state.dart';

import 'play_pause_button.dart';

class PlayStateButton extends StatelessWidget {
  const PlayStateButton({
    super.key,
    required this.playButtonState,
    required this.onPlay,
    required this.onPause,
    required this.buttonSize,
  });

  final PlayButtonState playButtonState;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        switch (playButtonState) {
          case PlayButtonState.loading:
            return const CircularProgressIndicator();
          case PlayButtonState.playing:
            return PlayPauseButton(
              callback: onPause,
              iconData: FontAwesomeIcons.pause,
              buttonSize: buttonSize,
            );
          case PlayButtonState.paused:
            return PlayPauseButton(
              callback: onPlay,
              iconData: FontAwesomeIcons.play,
              buttonSize: buttonSize,
            );
        }
      },
    );
  }
}
