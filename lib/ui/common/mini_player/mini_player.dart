import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/player_controller.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_image.dart';
import 'package:mulink/ui/music_player_screen/component/play_state_button.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();

    return GestureDetector(
      onTap: () => {},
      child: GetBuilder<PlaylistController>(
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      MediaThumbImage(
                        size: 40,
                        albumCoverData:
                            playlistController.currentPlayTrack?.albumCover,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OverflowMarquee(
                              text:
                                  playlistController.currentPlayTrack?.title ??
                                      "<unknown>",
                            ),
                            OverflowMarquee(
                              text:
                                  playlistController.currentPlayTrack?.artist ??
                                      "<unknown>",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const MiniPlayerControllPanel(),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
            ),
          ],
        );
      },
    );
  }
}
