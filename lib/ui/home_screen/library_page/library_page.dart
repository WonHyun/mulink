import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();
    return Column(
      children: [
        Expanded(
          child: GetBuilder<PlaylistController>(
            builder: (_) {
              return ListView.builder(
                itemCount: playlistController.playlist?.length,
                itemBuilder: (context, index) {
                  MediaItem? mediaItem = playlistController.playlist?[index];
                  return PlaylistItem(
                    mediaItem: mediaItem,
                    callback: (mediaItem) =>
                        playlistController.setCurrentTrack(mediaItem),
                    isSelected:
                        playlistController.currentPlayTrack == mediaItem,
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

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    super.key,
    required this.mediaItem,
    required this.callback,
    this.isSelected = false,
  });

  final MediaItem? mediaItem;
  final Function(MediaItem?) callback;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => callback(mediaItem),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.grey : Colors.grey.shade800,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      MediaThumbImage(
                        imagePath: mediaItem?.artUri?.path,
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: MediaThumbInfo(mediaItem: mediaItem)),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaThumbInfo extends StatelessWidget {
  const MediaThumbInfo({
    super.key,
    required this.mediaItem,
  });

  final MediaItem? mediaItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mediaItem?.title ?? "<unknown>",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          mediaItem?.artist ?? "<unknown>",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class MediaThumbImage extends StatelessWidget {
  const MediaThumbImage({
    super.key,
    required this.imagePath,
    this.size = 50,
  });

  final double? size;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath ?? "assets/images/basic_artwork.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
