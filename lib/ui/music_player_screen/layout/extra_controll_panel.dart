import 'package:flutter/material.dart';
import 'package:mulink/controller/player_controller.dart';

class ExtraControllPanel extends StatelessWidget {
  const ExtraControllPanel({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.lyrics_outlined),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.share_outlined),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.favorite_border),
            ),
          ],
        ),
      ],
    );
  }
}
