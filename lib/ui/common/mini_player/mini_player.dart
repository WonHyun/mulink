import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/service/util/image_util.dart';
import 'package:mulink/ui/common/mini_player/mini_player_controll_panel.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_image.dart';
import 'package:mulink/ui/music_player_screen/music_player_screen.dart';
import 'package:animations/animations.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();

    return GetBuilder<PlaylistController>(
      builder: (_) {
        BorderRadius borderRadius = BorderRadius.circular(50);
        Color playerColor = calculateAverageColor(
          imageData: playlistController.currentPlayTrack?.albumCover,
          themeColor: context.theme.colorScheme.surface,
        );
        return OpenContainer(
            closedElevation: 0,
            closedColor: playerColor,
            closedShape: RoundedRectangleBorder(borderRadius: borderRadius),
            openElevation: 0,
            openColor: playerColor,
            openBuilder: (BuildContext context, VoidCallback _) {
              return const MusicPlayerScreen();
            },
            transitionType: ContainerTransitionType.fade,
            transitionDuration: const Duration(milliseconds: 500),
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: playerColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Hero(
                            tag: "albumCover",
                            child: MediaThumbImage(
                              size: 40,
                              albumCoverData: playlistController
                                  .currentPlayTrack?.albumCover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OverflowMarquee(
                                  text: playlistController
                                          .currentPlayTrack?.title ??
                                      "<unknown>",
                                ),
                                OverflowMarquee(
                                  text: playlistController
                                          .currentPlayTrack?.artist ??
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
            });
      },
    );
  }
}
