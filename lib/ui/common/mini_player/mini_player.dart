import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/common/mini_player/mini_player_controll_panel.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_image.dart';
import 'package:mulink/ui/music_player_screen/music_player_screen.dart';
import 'package:animations/animations.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    final Color playerColor = queueState.trackColor ?? Colors.indigo;
    return Builder(
      builder: (context) {
        BorderRadius borderRadius = BorderRadius.circular(50);
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
                              albumCoverData:
                                  queueState.currentTrack?.albumCover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OverflowMarquee(
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  text: queueState.currentTrack?.title ??
                                      "<unknown>",
                                ),
                                OverflowMarquee(
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  text: queueState.currentTrack?.artist ??
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
