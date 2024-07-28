import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/audio_progress_bar.dart';
import 'package:mulink/ui/music_player_screen/layout/extra_controll_panel.dart';
import 'package:mulink/ui/music_player_screen/layout/music_page_view.dart';

import 'layout/player_controll_panel.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.watch(playerProvider.notifier);
    final queueState = ref.watch(queueProvider);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(queueState.currentTrack),
                decoration: BoxDecoration(
                  image: queueState.currentTrack?.albumCover != null
                      ? DecorationImage(
                          image: MemoryImage(
                            queueState.currentTrack!.albumCover!,
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            isDarkMode
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                            isDarkMode ? BlendMode.darken : BlendMode.lighten,
                          ),
                        )
                      : null,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15.0,
                    sigmaY: 15.0,
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
                              const Flexible(
                                flex: 10,
                                child: MusicPageView(),
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
            ),
          );
        },
      ),
    );
  }
}
