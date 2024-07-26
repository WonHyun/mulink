import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
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
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: queueState.currentTrack?.albumCover != null
                    ? DecorationImage(
                        image: MemoryImage(
                          queueState.currentTrack!.albumCover!,
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Column(
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
                        child: Column(
                          children: [
                            Flexible(
                              flex: 10,
                              child: PlayerTrackInfo(
                                track: queueState.currentTrack,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Flexible(
                              child: ExtraControllPanel(),
                            ),
                            Flexible(
                              flex: 1,
                              child: AudioProgressBar(
                                position: playerState.positionState,
                                onSeek: playerNotifier.seek,
                              ),
                            ),
                            const SizedBox(height: 10),
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
            ),
          );
        },
      ),
    );
  }
}
