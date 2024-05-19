import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/home_screen/library_page/media_list_item.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();
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
          child: GetBuilder<PlaylistController>(
            builder: (_) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: playlistController.playlist.length,
                itemBuilder: (context, index) {
                  Track? track = playlistController.playlist[index];
                  return MediaListItem(
                    track: track,
                    callback: () => playlistController.setCurrentTrack(track),
                    isSelected: playlistController.currentPlayTrack == track,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
