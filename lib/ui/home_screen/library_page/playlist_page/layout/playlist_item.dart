import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_image.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_info.dart';

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
