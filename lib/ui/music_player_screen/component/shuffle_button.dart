import 'package:flutter/material.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    super.key,
    required this.isShuffled,
    required this.onShuffle,
    required this.iconSize,
  });

  final bool isShuffled;
  final VoidCallback onShuffle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onShuffle,
      icon: Icon(Icons.shuffle, size: iconSize),
      color: isShuffled
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.inverseSurface,
    );
  }
}
