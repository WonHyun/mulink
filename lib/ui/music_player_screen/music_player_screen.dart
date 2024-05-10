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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerTrackInfo(playlistController: playlistController),
              const SizedBox(height: 20),
              ExtraControllPanel(controller: playerController),
              AudioProgressBar(controller: playerController),
              PlayerControllPanel(controller: playerController),
            ],
          ),
        ),
      ),
    );
  }
}
