import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/music_player_screen/layout/player_track_info.dart';

class MusicPageView extends ConsumerStatefulWidget {
  const MusicPageView({
    super.key,
  });

  @override
  ConsumerState<MusicPageView> createState() => _MusicPageViewState();
}

class _MusicPageViewState extends ConsumerState<MusicPageView> {
  late final PageController _controller;

  int _index = 0;

  @override
  void initState() {
    super.initState();

    final queue = ref.read(queueProvider).queue;
    final currentTrack = ref.read(queueProvider).currentTrack;
    if (currentTrack != null) {
      _index = queue.indexOf(currentTrack);
    }

    _controller = PageController(initialPage: _index);

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
    final queue = ref.watch(queueProvider).queue;
    return PageView.builder(
      controller: _controller,
      itemCount: queue.length,
      itemBuilder: (context, index) {
        final track = queue[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PlayerTrackInfo(track: track),
        );
      },
    );
  }
}
