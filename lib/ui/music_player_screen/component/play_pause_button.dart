import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        color: context.theme.colorScheme.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: context.theme.colorScheme.secondary,
          onTap: callback.call,
          child: Icon(
            iconData,
            color: context.theme.colorScheme.inverseSurface,
            size: buttonSize / 1.5,
          ),
        ),
      ),
    );
  }
}
