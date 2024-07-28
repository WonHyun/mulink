import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';
import 'package:mulink/ui/music_player_screen/layout/media_info_marquee.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo({
    super.key,
    required this.track,
  });

  final Track? track;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AlbumCoverImage(
            albumCoverData: track?.albumCover,
          ),
        ),
        const SizedBox(height: 30),
        MediaInfoMarquee(track: track),
      ],
    );
  }
}
