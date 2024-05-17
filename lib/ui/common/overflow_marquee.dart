import 'package:flutter/material.dart';
import 'package:mulink/ui/common/marquee.dart';

class OverflowMarquee extends StatelessWidget {
  const OverflowMarquee({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(),
  });

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();

        if (textPainter.width >= constraints.maxWidth) {
          return SizedBox(
            height: textPainter.height,
            child: Marquee(
              text: text,
              style: textStyle,
              blankSpace: 50,
              fadingEdgeStartFraction: 0.05,
              fadingEdgeEndFraction: 0.05,
              pauseAfterRound: const Duration(seconds: 2),
            ),
          );
        } else {
          return Text(
            text,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
      }),
    );
  }
}
