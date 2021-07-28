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

  final oldColor = image.getPixel(startX, startY);

  // Prevent infinite loop. Not neccessary when filled area is written to an empty image.
  if (_closeEnough(oldColor, color)) return imageBytes;

  final q = Queue<List<int>>();
  q.add([startX, startY]);

  int xl, xr;

  bool shouldFill(int x, int y) {
    return _closeEnough(image.getPixel(x, y), oldColor);
  }

  while (q.isNotEmpty) {
    final coord = q.removeFirst();
    final x = coord[0];
    final y = coord[1];

    xl = xr = x;

    while (xl - 1 >= 0 && shouldFill(xl - 1, y)) xl--;

    for (var x = xl; x < image.width && shouldFill(x, y); x++) {
      image.setPixel(x, y, color);
      xr = x;
    }

    if (y > 0) _scanLine(xl, xr, y - 1, shouldFill, q);
    if (y < image.height - 1) _scanLine(xl, xr, y + 1, shouldFill, q);
  }

  return image.bytes;
}

typedef ShouldFill = bool Function(int x, int y);

void _scanLine(
  int xl,
  int xr,
  int y,
  ShouldFill shouldFill,
  Queue<List<int>> q,
) {
  bool streak = false;

  for (; xl <= xr; xl++) {
    if (!streak && shouldFill(xl, y)) {
      q.add([xl, y]);
      streak = true;
    } else if (streak && !shouldFill(xl, y)) {
      streak = false;
    }
  }
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
