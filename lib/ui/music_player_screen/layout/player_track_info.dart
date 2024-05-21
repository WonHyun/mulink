import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';

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
        Flexible(
          child: Hero(
            tag: "albumCover",
            child: AlbumCoverImage(
              albumCoverData: track?.albumCover,
            ),
          ),
        ),
        const SizedBox(height: 30),
        OverflowMarquee(
          text: track?.title ?? "<unknown>",
          textStyle: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        OverflowMarquee(
          text: track?.artist ?? "<unknown>",
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
