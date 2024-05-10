import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mulink/ui/common/mini_player/mini_player.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/playlist_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        PlaylistPage(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: MiniPlayer(),
          ),
        ),
      ],
    );
  }
}
