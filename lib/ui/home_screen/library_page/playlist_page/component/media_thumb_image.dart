import 'dart:typed_data';
import 'package:flutter/material.dart';

class MediaThumbImage extends StatelessWidget {
  const MediaThumbImage({
    super.key,
    this.albumCoverData,
    this.size = 50,
  });

  final double? size;
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
            : const DecorationImage(
                image: AssetImage("assets/images/basic_artwork.png"),
                fit: BoxFit.cover,
              ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
