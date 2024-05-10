import 'dart:typed_data';
import 'package:flutter/material.dart';

class MediaThumbImage extends StatelessWidget {
  const MediaThumbImage({
    super.key,
    this.imagePath,
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
