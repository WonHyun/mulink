import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';

class MediaThumbInfo extends StatelessWidget {
  const MediaThumbInfo({
    super.key,
    required this.track,
  });

  final Track? track;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track?.title ?? "<unknown>",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          track?.artist ?? "<unknown>",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
