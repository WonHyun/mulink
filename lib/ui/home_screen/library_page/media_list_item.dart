import 'package:flutter/material.dart';
import 'package:mulink/model/track.dart';
import 'package:mulink/ui/home_screen/library_page/playlist_page/component/media_thumb_image.dart';

class MediaListItem extends StatelessWidget {
  const MediaListItem({
    super.key,
    required this.track,
    required this.onSelect,
    required this.isSelected,
  });

  final Track track;
  final VoidCallback onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: MediaThumbImage(
        albumCoverData: track.albumCover,
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      selected: isSelected,
      onTap: onSelect,
    );
  }
}
