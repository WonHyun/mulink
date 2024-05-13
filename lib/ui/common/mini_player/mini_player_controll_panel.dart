import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/ui/music_player_screen/component/play_state_button.dart';

class MiniPlayerControllPanel extends StatelessWidget {
  const MiniPlayerControllPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find();
    return GetBuilder<PlayerController>(
      builder: (_) {
        return Row(
          children: [
            IconButton(
              onPressed: playerController.previous,
              icon: const Icon(Icons.skip_previous),
              color: context.theme.colorScheme.inverseSurface,
            ),
            PlayStateButton(
              playButtonState: playerController.playButtonState,
              playCallback: playerController.play,
              pauseCallback: playerController.pause,
              buttonSize: 40,
            ),
            IconButton(
              onPressed: playerController.next,
              icon: const Icon(Icons.skip_next),
              color: context.theme.colorScheme.inverseSurface,
            ),
          ],
        );
      },
    );
  }
}
