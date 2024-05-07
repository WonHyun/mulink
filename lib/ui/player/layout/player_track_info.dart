import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/player/component/album_cover_image.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo({
    super.key,
    required this.playlistController,
  });

  final PlaylistController playlistController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaylistController>(
      builder: (_) {
        return Column(
          children: [
            AlbumCoverImage(
              maxWidth: 400,
              imgPath: playlistController.currentPlayTrack?.artUri?.path,
            ),
            const SizedBox(height: 30),
            OverflowMarquee(
              text: playlistController.currentPlayTrack?.title ?? "<unknown>",
              textStyle: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            OverflowMarquee(
              text: playlistController.currentPlayTrack?.artist ?? "<unknown>",
              textStyle: context.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
