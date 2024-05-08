import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mulink/global/extension/context_extension.dart';
import 'dart:math' as math;

class AlbumCoverImage extends StatelessWidget {
  const AlbumCoverImage({
    super.key,
    required this.maxWidth,
    this.width,
    this.height,
    this.imgPath,
    this.albumCoverData,
  });

  final double? width;
  final double? height;
  final double maxWidth;
  final String? imgPath;
  final Uint8List? albumCoverData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? math.min(context.deviceWidth, maxWidth),
      height: height ?? math.min(context.deviceWidth, maxWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: albumCoverData != null
            ? DecorationImage(
                image: MemoryImage(albumCoverData!),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage(imgPath ?? 'assets/images/basic_artwork.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
