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
  final image = _Image(imageBytes, imageWidth, imageHeight);

  final originalColor = image.getPixel(startX, startY);

  for (int x = 0; x < imageWidth; x++) {
    for (int y = 0; y < imageHeight; y++) {
      if (image.getPixel(x, y) == originalColor) {
        image.setPixel(x, y, color);
      }
    }
  }
  return imageBytes;
}

class _Image {
  _Image(this.bytes, this.width, this.height);

  final ByteData bytes;
  final int width;
  final int height;

  bool withinBounds(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  int _byteOffset(int x, int y) => (y * width + x) * 4;

  int getPixel(int x, int y) {
    return bytes.getUint32(_byteOffset(x, y));
  }

  void setPixel(int x, int y, int color) {
    return bytes.setUint32(_byteOffset(x, y), color);
  }
}
