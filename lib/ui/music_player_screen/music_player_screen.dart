import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/music_screen_body.dart';
import 'package:mulink/ui/music_player_screen/music_playlist_screen.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({
    super.key,
  });

  void _onTapBottom(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          final position = Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(curved);

          return SlideTransition(
            position: position,
            child: const MusicPlaylistScreen(),
          );
        },
      ),
    );
  }

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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IconButton(
                onPressed: () => _onTapBottom(context),
                icon: const Icon(FontAwesomeIcons.chevronDown),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
