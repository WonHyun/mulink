import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';

import '../component/play_state_button.dart';
import '../component/repeat_button.dart';
import '../component/shuffle_button.dart';

class MediaControllPanel extends StatelessWidget {
  const MediaControllPanel({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShuffleButton(
              isShuffled: controller.isShuffled,
              callback: controller.toggleShuffle,
            ),
            IconButton(
              onPressed: controller.previous,
              icon: const Icon(
                Icons.skip_previous,
                size: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PlayStateButton(
                playButtonState: controller.playButtonState,
                playCallback: controller.play,
                pauseCallback: controller.pause,
              ),
            ),
            IconButton(
              onPressed: controller.next,
              icon: const Icon(
                Icons.skip_next,
                size: 50,
              ),
            ),
            RepeatButton(
              repeatState: controller.repeatState,
              callback: controller.toggleRepeatMode,
            ),
          ],
        );
      },
    );
  }
}
