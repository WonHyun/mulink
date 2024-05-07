import 'package:flutter/material.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    super.key,
    required this.isShuffled,
    required this.callback,
  });

  final bool isShuffled;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback.call,
      icon: const Icon(Icons.shuffle, size: 50),
      color: isShuffled ? Colors.cyan.shade300 : Colors.grey,
    );
  }
}
