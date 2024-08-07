import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AlbumCoverImage extends StatelessWidget {
  const AlbumCoverImage({
    super.key,
    this.width,
    this.height,
    this.maxSize = 400,
    this.albumCoverData,
  });

  final double? width;
  final double? height;
  final double maxSize;
  final Uint8List? albumCoverData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width ?? math.min(constraints.biggest.shortestSide, maxSize),
          height: height ?? math.min(constraints.biggest.shortestSide, maxSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              )
            ],
            image: albumCoverData != null
                ? DecorationImage(
                    image: MemoryImage(albumCoverData!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage("assets/images/basic_artwork.png"),
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }
}
