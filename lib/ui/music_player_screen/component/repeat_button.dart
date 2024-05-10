import 'package:flutter/material.dart';
import 'package:mulink/controller/player_controller.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    super.key,
    required this.repeatState,
    required this.callback,
    required this.iconSize,
  });

  final RepeatState repeatState;
  final VoidCallback callback;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fontSize = iconSize / 3;
    return IconButton(
      onPressed: callback.call,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: repeatState == RepeatState.off
                ? Colors.grey
                : Colors.cyan.shade300,
          ),
          Builder(
            builder: (context) {
              switch (repeatState) {
                case RepeatState.off:
                  return const Text("");
                case RepeatState.repeatPlaylist:
                  return Text(
                    "A",
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.cyan.shade300,
                    ),
                  );
                case RepeatState.repeatSong:
                  return Text(
                    "1",
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.cyan.shade300,
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
