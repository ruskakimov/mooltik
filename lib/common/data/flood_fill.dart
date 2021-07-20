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

  // _fill(image, originalColor, color, startX, startY);

  for (int x = 0; x < imageWidth; x++) {
    for (int y = 0; y < imageHeight; y++) {
      final pixel = image.getPixel(x, y);
      if (pixel != 0x00000000) {
        // image.setPixel(x, y, 0xFFFFFFFF);
        final originalAlpha = pixel & 0x000000FF;
        final rgb = color & 0xFFFFFF00;

        // if (originalAlpha != 0xFF) {
        //   print('$x $y');
        //   print((originalAlpha | rgb).toRadixString(16).padRight(8, '0'));
        // }
        image.setPixel(x, y, originalAlpha | rgb);
      }
    }
  }

  return image.bytes;
}

void _fill(
  _Image image,
  int originalColor,
  int replacementColor,
  int x,
  int y,
) {
  if (!image.withinBounds(x, y)) return;

  if (image.getPixel(x, y) == originalColor) {
    image.setPixel(x, y, replacementColor);
    _fill(image, originalColor, replacementColor, x - 1, y);
    _fill(image, originalColor, replacementColor, x + 1, y);
    _fill(image, originalColor, replacementColor, x, y - 1);
    _fill(image, originalColor, replacementColor, x, y + 1);
  }
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
