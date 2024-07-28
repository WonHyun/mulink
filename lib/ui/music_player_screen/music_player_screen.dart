import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/music_screen_body.dart';
import 'package:mulink/ui/music_player_screen/music_playlist_screen.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
  const MusicPlayerScreen({
    super.key,
  });

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: 1000.ms,
  );

  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOutCubic,
  );

  late final Animation<Offset> _firstOffset = Tween(
    begin: Offset.zero,
    end: const Offset(0, -1),
  ).animate(_curved);

  late final Animation<Offset> _secondOffset = Tween(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(_curved);

  void _toggleSlide() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(queueProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      child: AnimatedBuilder(
          animation: _curved,
          builder: (context, child) {
            return Stack(
              children: [
                SlideTransition(
                  position: _firstOffset,
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
                                image: queueState.currentTrack?.albumCover !=
                                        null
                                    ? DecorationImage(
                                        image: MemoryImage(
                                          queueState.currentTrack!.albumCover!,
                                        ),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          isDarkMode
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.white.withOpacity(0.5),
                                          isDarkMode
                                              ? BlendMode.darken
                                              : BlendMode.lighten,
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
                            onPressed: _toggleSlide,
                            icon: const Icon(FontAwesomeIcons.chevronDown),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SlideTransition(
                  position: _secondOffset,
                  child: MusicPlaylistScreen(onTapUp: _toggleSlide),
                ),
              ],
            );
          }),
    );
  }
}
