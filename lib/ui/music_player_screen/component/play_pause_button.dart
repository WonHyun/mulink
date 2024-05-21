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
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: Theme.of(context).colorScheme.secondary,
          onTap: callback,
          child: Icon(
            iconData,
            color: Theme.of(context).colorScheme.inverseSurface,
            size: buttonSize / 1.5,
          ),
        ),
      ),
    );
  }
}
