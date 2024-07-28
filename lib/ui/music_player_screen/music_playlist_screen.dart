import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulink/global/enum.dart';
import 'package:mulink/providers/providers.dart';
import 'package:mulink/ui/common/overflow_marquee.dart';
import 'package:mulink/ui/music_player_screen/component/album_cover_image.dart';
import 'package:mulink/ui/music_player_screen/layout/media_control_panel.dart';

class MusicPlaylistScreen extends ConsumerWidget {
  const MusicPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    return PopScope(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(FontAwesomeIcons.chevronUp),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Hero(
                      tag: HeroTags.albumCoverImage,
                      child: AlbumCoverImage(
                        maxSize: 60,
                        albumCoverData: queueState.currentTrack?.albumCover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OverflowMarquee(
                            text: queueState.currentTrack?.title ?? "<unknown>",
                          ),
                          OverflowMarquee(
                            text:
                                queueState.currentTrack?.artist ?? "<unknown>",
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
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: queueState.queue.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => ref
                                .read(queueProvider.notifier)
                                .setCurrentTrack(queueState.queue[index]),
                            textColor: queueState.queue[index] ==
                                    queueState.currentTrack
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            leading: AlbumCoverImage(
                              albumCoverData:
                                  queueState.queue[index].albumCover,
                            ),
                            title: Text(
                              queueState.queue[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              queueState.queue[index].artist ??
                                  "<unknown artist>",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
