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
  final srcImage = _Image(imageBytes, imageWidth, imageHeight);

  /// Black image where filled area is marked by white pixels.
  final fillMask = _Image(
    ByteData(imageBytes.lengthInBytes),
    imageWidth,
    imageHeight,
  );

  final startColor = srcImage.getPixel(startX, startY);

  bool isFilled(int x, int y) => fillMask.getPixel(x, y) != 0;

  void fillPixel(int x, int y) {
    fillMask.setPixel(x, y, 0xFFFFFFFF);
    srcImage.setPixel(x, y, color);
  }

  bool shouldFill(int x, int y) =>
      srcImage.withinBounds(x, y) &&
      !isFilled(x, y) &&
      _closeEnough(
        srcImage.getPixel(x, y),
        startColor,
      );

  if (!shouldFill(startX, startY)) return imageBytes;

  final q = Queue<List<int>>();
  q.add([startX, startY]);

  while (q.isNotEmpty) {
    final coord = q.removeFirst();
    final x = coord[0];
    final y = coord[1];

    if (shouldFill(x, y)) {
      fillPixel(x, y);
      q.add([x + 1, y]);
      q.add([x - 1, y]);
      q.add([x, y + 1]);
      q.add([x, y - 1]);
    }
  }

  return srcImage.bytes;
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
