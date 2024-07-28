import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.callback,
    required this.iconData,
    required this.buttonSize,
    this.iconColor = Colors.white,
  });

  final VoidCallback callback;
  final IconData iconData;
  final double buttonSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback,
      icon: Icon(
        iconData,
        color: iconColor,
        size: buttonSize,
      ),
    );
  }
}
