import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mulink/controller/playlist_controller.dart';
import 'package:mulink/model/track.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();
    return Column(
      children: [
        IconButton(
          onPressed: playlistController.getAudioFilesFromDirectory,
          icon: const Icon(Icons.folder_open),
        ),
        Expanded(
          child: GetBuilder<PlaylistController>(
            builder: (_) {
              return ListView.builder(
                itemCount: playlistController.playlist.length,
                itemBuilder: (context, index) {
                  Track? track = playlistController.playlist[index];
                  return PlaylistItem(
                    track: track,
                    callback: (trackItem) =>
                        playlistController.setCurrentTrack(trackItem),
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

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    super.key,
    required this.track,
    required this.callback,
    this.isSelected = false,
  });

  final Track? track;
  final Function(Track?) callback;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => callback(track),
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
                        imagePath: track?.artUri?.path,
                        albumCoverData: track?.albumCover,
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: MediaThumbInfo(track: track)),
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
    required this.track,
  });

  final Track? track;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track?.title ?? "<unknown>",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          track?.artist ?? "<unknown>",
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
    this.albumCoverData,
    this.size = 50,
  });

  final double? size;
  final String? imagePath;
  final Uint8List? albumCoverData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: albumCoverData != null
            ? DecorationImage(
                image: MemoryImage(albumCoverData!),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image:
                    AssetImage(imagePath ?? "assets/images/basic_artwork.png"),
                fit: BoxFit.cover,
              ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
