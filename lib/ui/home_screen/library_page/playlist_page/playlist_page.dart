import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/providers/providers.dart';

import 'package:mulink/ui/home_screen/library_page/media_list_item.dart';

class PlaylistPage extends ConsumerWidget {
  const PlaylistPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    final queueNotifier = ref.watch(queueProvider.notifier);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Text("All Tracks"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: queueState.queue.length,
            itemBuilder: (context, index) {
              Track? track = queueState.queue[index];
              return MediaListItem(
                track: track,
                onSelect: () => queueNotifier.setCurrentTrack(track),
                isSelected: queueState.currentTrack == track,
              );
            },
          ),
        ),
      ],
    );
  }
}
