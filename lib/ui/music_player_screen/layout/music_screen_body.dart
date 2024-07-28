import 'package:flutter/material.dart';
import 'package:mulink/ui/music_player_screen/layout/audio_progress_bar.dart';
import 'package:mulink/ui/music_player_screen/layout/extra_controll_panel.dart';
import 'package:mulink/ui/music_player_screen/layout/music_page_view.dart';
import 'package:mulink/ui/music_player_screen/layout/player_controll_panel.dart';

class MusicScreenBody extends StatelessWidget {
  const MusicScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          ),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.more_vert, size: 30),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: const Column(
              children: [
                Flexible(
                  flex: 10,
                  child: MusicPageView(),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: ExtraControllPanel(),
                ),
                Flexible(
                  flex: 1,
                  child: AudioProgressBar(),
                ),
                SizedBox(height: 10),
                Flexible(
                  flex: 2,
                  child: PlayerControllPanel(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
