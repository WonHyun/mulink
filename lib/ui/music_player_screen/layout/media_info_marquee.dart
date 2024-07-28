import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';

class MediaInfoMarquee extends StatelessWidget {
  const MediaInfoMarquee({
    super.key,
    required this.track,
  });

  final Track? track;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          OverflowMarquee(
            text: track?.title ?? "<unknown>",
            textStyle: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          OverflowMarquee(
            text: track?.artist ?? "<unknown>",
            textStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
