import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/global/extension/context_extension.dart';

import '../component/play_state_button.dart';
import '../component/repeat_button.dart';
import '../component/shuffle_button.dart';

import 'dart:math' as math;

class MediaControllPanel extends StatelessWidget {
  const MediaControllPanel({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final iconSize = math.min(context.deviceWidth / 10, 50.0);
    return GetBuilder<PlayerController>(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShuffleButton(
              isShuffled: controller.isShuffled,
              callback: controller.toggleShuffle,
              iconSize: iconSize,
            ),
            IconButton(
              onPressed: controller.previous,
              icon: Icon(
                Icons.skip_previous,
                size: iconSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PlayStateButton(
                playButtonState: controller.playButtonState,
                playCallback: controller.play,
                pauseCallback: controller.pause,
                iconSize: iconSize,
              ),
            ),
            IconButton(
              onPressed: controller.next,
              icon: Icon(
                Icons.skip_next,
                size: iconSize,
              ),
            ),
            RepeatButton(
              repeatState: controller.repeatState,
              callback: controller.toggleRepeatMode,
              iconSize: iconSize,
            ),
          ],
        );
      },
    );
  }
}
