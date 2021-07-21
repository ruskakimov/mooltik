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

  _fill(image, originalColor, color, startX, startY);

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

  if (_closeEnough(originalColor, image.getPixel(x, y))) {
    image.setPixel(x, y, replacementColor);
    _fill(image, originalColor, replacementColor, x - 1, y);
    _fill(image, originalColor, replacementColor, x + 1, y);
    _fill(image, originalColor, replacementColor, x, y - 1);
    _fill(image, originalColor, replacementColor, x, y + 1);
  }
}

bool _closeEnough(int originalColor, int pixelColor) {
  return (originalColor - pixelColor).abs() < 5;
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
