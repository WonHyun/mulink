import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';
import 'package:mulink/ui/music_player_screen/layout/media_info_marquee.dart';

class MusicPageView extends ConsumerStatefulWidget {
  const MusicPageView({
    super.key,
  });

  @override
  ConsumerState<MusicPageView> createState() => _MusicPageViewState();
}

class _MusicPageViewState extends ConsumerState<MusicPageView> {
  late final PageController _controller;

  late int _index;

  @override
  void initState() {
    super.initState();

    final currentIndex = ref.read(queueProvider.notifier).currentTrackIndex;
    _controller = PageController(initialPage: currentIndex);
    _index = currentIndex;

    _controller.addListener(() {
      if (_controller.page != null) {
        if ((_controller.page! - _index.toDouble()).abs() >= 1.0) {
          _index = _controller.page!.truncate();
          final queue = ref.read(queueProvider).queue;
          ref.read(queueProvider.notifier).setCurrentTrack(queue[_index]);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.read(queueProvider).queue;
    return PageView.builder(
      controller: _controller,
      itemCount: queue.length,
      itemBuilder: (context, index) {
        final track = queue[index];
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            var scale = 1.0;
            var opacity = 1.0;
            if (_controller.position.haveDimensions) {
              scale = (1 - ((index - _controller.page!).abs() * 0.1))
                  .clamp(0.0, 1.0);
              opacity = (1 - ((index - _controller.page!).abs() * 0.5))
                  .clamp(0.0, 1.0);
            }
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Column(
                  children: [
                    Expanded(
                      child: AlbumCoverImage(
                        albumCoverData: track.albumCover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    MediaInfoMarquee(track: track),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
