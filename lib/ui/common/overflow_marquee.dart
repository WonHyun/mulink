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
          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.white, Colors.white, Colors.transparent],
                stops: [0.0, 0.95, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              height: textPainter.height,
              child: Marquee(
                text: text,
                style: textStyle,
                blankSpace: 50,
                pauseAfterRound: const Duration(seconds: 2),
              ),
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
