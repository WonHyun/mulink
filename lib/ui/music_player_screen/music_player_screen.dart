import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/service/util/image_util.dart';
import 'package:mulink/ui/music_player_screen/layout/audio_progress_bar.dart';
import 'package:mulink/ui/music_player_screen/layout/extra_controll_panel.dart';

import 'layout/player_controll_panel.dart';
import 'layout/player_track_info.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.watch(playerProvider.notifier);
    final queueState = ref.watch(queueProvider);

    return PopScope(
      child: Builder(
        builder: (context) {
          Color trackColor = calculateAverageColor(
            imageData: queueState.currentTrack?.albumCover,
            themeColor: Theme.of(context).colorScheme.surface,
          );
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                color: trackColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: AppBar(
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
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 10,
                            child: PlayerTrackInfo(
                              track: queueState.currentTrack,
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: ExtraControllPanel(),
                          ),
                          Flexible(
                            flex: 1,
                            child: AudioProgressBar(
                              position: playerState.positionState,
                              onSeek: playerNotifier.seek,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: PlayerControllPanel(
                              state: playerState,
                              notifier: playerNotifier,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
