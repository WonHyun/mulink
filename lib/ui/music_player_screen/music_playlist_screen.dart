import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';
import 'package:mulink/ui/music_player_screen/layout/media_control_panel.dart';

class MusicPlaylistScreen extends ConsumerStatefulWidget {
  const MusicPlaylistScreen({
    super.key,
    required this.onTapUp,
  });

  final Function() onTapUp;

  @override
  ConsumerState<MusicPlaylistScreen> createState() =>
      _MusicPlaylistScreenState();
}

class _MusicPlaylistScreenState extends ConsumerState<MusicPlaylistScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        const itemHeight = 65.0;
        final index = ref.read(queueProvider.notifier).currentTrackIndex;

        double scrollPosition = index == 0 ? 0.0 : itemHeight * (index - 1);

        _controller.jumpTo(scrollPosition);
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
    final queueState = ref.watch(queueProvider);
    return SafeArea(
      child: PopScope(
        onPopInvoked: (didPop) => widget.onTapUp,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: queueState.trackColor ?? Theme.of(context).colorScheme.surface,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: widget.onTapUp,
                          icon: const Icon(FontAwesomeIcons.chevronUp),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      AlbumCoverImage(
                        maxSize: 60,
                        albumCoverData: queueState.currentTrack?.albumCover,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OverflowMarquee(
                              text:
                                  queueState.currentTrack?.title ?? "<unknown>",
                            ),
                            OverflowMarquee(
                              text: queueState.currentTrack?.artist ??
                                  "<unknown>",
                            ),
                          ],
                        ),
                      ),
                      const MediaControlPanel(
                        iconSize: 30,
                        horizontalPadding: 0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      child: ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: queueState.queue.length,
                        itemBuilder: (context, index) {
                          final track = queueState.queue[index];
                          final nowPlaying = queueState.currentTrack;
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(),
                              ),
                            ),
                            child: ListTile(
                              tileColor: track == nowPlaying
                                  ? Colors.deepPurple
                                  : null,
                              onTap: () => ref
                                  .read(queueProvider.notifier)
                                  .setCurrentTrack(track),
                              textColor:
                                  track == nowPlaying ? Colors.white : null,
                              leading: AlbumCoverImage(
                                albumCoverData: track.albumCover,
                              ),
                              title: Text(
                                track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                track.artist ?? "<unknown artist>",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
