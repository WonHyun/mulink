import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/ui/music_player_screen/layout/audio_progress_bar.dart';
import 'package:mulink/ui/music_player_screen/layout/extra_controll_panel.dart';

import 'layout/player_controll_panel.dart';
import 'layout/player_track_info.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find();
    final PlaylistController playlistController = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.more_horiz, size: 30),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 6,
                child: PlayerTrackInfo(playlistController: playlistController)),
            Flexible(
                flex: 1,
                child: ExtraControllPanel(controller: playerController)),
            Flexible(
                flex: 1, child: AudioProgressBar(controller: playerController)),
            Flexible(
                flex: 2,
                child: PlayerControllPanel(controller: playerController)),
          ],
        ),
      ),
    );
  }
}
