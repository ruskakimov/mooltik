import 'dart:typed_data';

/// Fills image represented by [imageBytes], [imageWidth], and [imageHeight]
/// starting at [startX], [startY]
/// with the given [color].
ByteData floodFill(
  ByteData imageBytes,
  int imageWidth,
  int imageHeight,
  int startX,
  int startY,
  int color,
) {
  int getPixel(int x, int y) {
    return imageBytes.getUint32((y * imageWidth + x) * 4);
  }

  void setPixel(int x, int y, int color) {
    return imageBytes.setUint32((y * imageWidth + x) * 4, color);
  }

  final originalColor = getPixel(startX, startY);

  for (int x = 0; x < imageWidth; x++) {
    for (int y = 0; y < imageHeight; y++) {
      if (getPixel(x, y) == originalColor) {
        setPixel(x, y, color);
      }
    }
  }
  return imageBytes;
}
