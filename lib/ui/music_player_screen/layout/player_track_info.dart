import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo({
    super.key,
    required this.controller,
  });

  final PlaylistController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaylistController>(
      builder: (_) {
        return Column(
          children: [
            Hero(
              tag: "albumCover",
              child: AlbumCoverImage(
                imgPath: controller.currentPlayTrack?.artUri?.path,
                albumCoverData: controller.currentPlayTrack?.albumCover,
              ),
            ),
            const SizedBox(height: 30),
            OverflowMarquee(
              text: controller.currentPlayTrack?.title ?? "<unknown>",
              textStyle: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            OverflowMarquee(
              text: controller.currentPlayTrack?.artist ?? "<unknown>",
              textStyle: context.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
