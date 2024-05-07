import 'package:flutter/material.dart';
import 'package:mulink/controller/player_controller.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    super.key,
    required this.repeatState,
    required this.callback,
  });

  final RepeatState repeatState;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback.call,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: 50,
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
                      fontSize: 12,
                      color: Colors.cyan.shade300,
                    ),
                  );
                case RepeatState.repeatSong:
                  return Text(
                    "1",
                    style: TextStyle(
                      fontSize: 12,
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
