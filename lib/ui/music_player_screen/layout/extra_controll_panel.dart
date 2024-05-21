import 'package:flutter/material.dart';

class ExtraControllPanel extends StatelessWidget {
  const ExtraControllPanel({
    super.key,
  });

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
