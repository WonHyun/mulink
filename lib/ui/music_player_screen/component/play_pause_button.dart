import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.callback,
    required this.iconData,
    required this.iconSize,
  });

  final VoidCallback callback;
  final IconData iconData;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.cyan.shade300,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: Colors.cyan,
          onTap: callback.call,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
