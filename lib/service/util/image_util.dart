import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart' as img;

Color calculateAverageColor({
  Uint8List? imageData,
  double brightness = 0.5,
  required Color themeColor,
}) {
  if (imageData == null) return themeColor;

  img.Image? image = img.decodeImage(imageData);
  if (image == null) return themeColor;

  int rTotal = 0, gTotal = 0, bTotal = 0;
  int pixelCount = image.width * image.height;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      img.Pixel pixel = image.getPixel(x, y);
      rTotal += pixel.r as int;
      gTotal += pixel.g as int;
      bTotal += pixel.b as int;
    }
  }

  int rAvg = rTotal ~/ pixelCount;
  int gAvg = gTotal ~/ pixelCount;
  int bAvg = bTotal ~/ pixelCount;

  return Color.fromRGBO(
    (rAvg * brightness).round(),
    (gAvg * brightness).round(),
    (bAvg * brightness).round(),
    1.0,
  );
}
