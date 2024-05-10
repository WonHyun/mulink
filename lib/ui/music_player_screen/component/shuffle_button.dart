import 'package:flutter/material.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    super.key,
    required this.isShuffled,
    required this.callback,
    required this.iconSize,
  });

  final bool isShuffled;
  final VoidCallback callback;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback.call,
      icon: Icon(Icons.shuffle, size: iconSize),
      color: isShuffled ? Colors.cyan.shade300 : Colors.grey,
    );
  }
}
