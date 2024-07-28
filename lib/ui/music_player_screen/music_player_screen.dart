import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/music_screen_body.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
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
                    child: const MusicScreenBody(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
