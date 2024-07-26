import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/states/music_player_state.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
    required this.loopState,
    required this.onLoop,
    required this.iconSize,
  });

  final LoopState loopState;
  final VoidCallback onLoop;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fontSize = iconSize / 3;
    return IconButton(
      onPressed: onLoop,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.repeat,
            size: iconSize,
            color: loopState == LoopState.off
                ? Theme.of(context).colorScheme.inverseSurface
                : Theme.of(context).colorScheme.primary,
          ),
          Builder(
            builder: (context) {
              switch (loopState) {
                case LoopState.off:
                  return const Text("");
                case LoopState.loopAll:
                  return Text(
                    "A",
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                case LoopState.loopOne:
                  return Text(
                    "1",
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                default:
                  return const Text("");
              }
            },
          ),
        ],
      ),
    );
  }
}
