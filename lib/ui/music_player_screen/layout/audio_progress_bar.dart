import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<PlayerController>(
        builder: (_) {
          return ProgressBar(
            progress: controller.progressBarState.current,
            buffered: controller.progressBarState.buffered,
            total: controller.progressBarState.total,
            onSeek: controller.seek,
            thumbColor: Colors.cyan.shade300,
            baseBarColor: Colors.grey.shade700,
            progressBarColor: Colors.cyan.shade300,
            bufferedBarColor: Colors.grey,
          );
        },
      ),
    );
  }
}
