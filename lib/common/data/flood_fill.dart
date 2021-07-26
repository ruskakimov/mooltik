import 'dart:collection';
import 'dart:typed_data';

/// Fills image represented by [imageBytes], [imageWidth], and [imageHeight]
/// with the given [color]
/// starting at [startX], [startY].
ByteData floodFill(
  ByteData imageBytes,
  int imageWidth,
  int imageHeight,
  int startX,
  int startY,
  int color,
) {
  final image = _Image(imageBytes, imageWidth, imageHeight);

  final startColor = image.getPixel(startX, startY);

  // Prevent infinite loop. Not neccessary when filled area is written to an empty image.
  if (_closeEnough(startColor, color)) return imageBytes;

  final q = Queue<List<int>>();
  q.add([startX, startY]);

  while (q.isNotEmpty) {
    final coord = q.removeFirst();
    final x = coord[0];
    final y = coord[1];

    if (!image.withinBounds(x, y)) continue;

    final pixelColor = image.getPixel(x, y);

    if (_closeEnough(startColor, pixelColor)) {
      image.setPixel(x, y, color);
      q.add([x + 1, y]);
      q.add([x - 1, y]);
      q.add([x, y + 1]);
      q.add([x, y - 1]);
    }
  }

  return image.bytes;
}

bool _closeEnough(int colorA, int colorB) {
  return (colorA - colorB).abs() < 5;
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
