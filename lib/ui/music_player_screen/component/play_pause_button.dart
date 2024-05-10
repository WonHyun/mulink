import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.callback,
    required this.iconData,
    required this.buttonSize,
  });

  final VoidCallback callback;
  final IconData iconData;
  final double buttonSize;

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
          child: Icon(
            iconData,
            color: Colors.white,
            size: buttonSize / 1.5,
          ),
        ),
      ),
    );
  }
}
