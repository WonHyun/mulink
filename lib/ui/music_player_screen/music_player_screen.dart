import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/service/util/image_util.dart';
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
    return PopScope(
      child: GetBuilder<PlaylistController>(
        builder: (_) {
          Color trackColor = calculateAverageColor(
              imageData: playlistController.currentPlayTrack?.albumCover);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, trackColor],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
                        ),
                        IconButton(
                          onPressed: () => {},
                          icon: const Icon(Icons.more_vert, size: 30),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 10,
                            child: PlayerTrackInfo(
                              controller: playlistController,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ExtraControllPanel(
                              controller: playerController,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: AudioProgressBar(
                              controller: playerController,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: PlayerControllPanel(
                              controller: playerController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
