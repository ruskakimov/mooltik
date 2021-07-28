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
  q.add([startX, startY, 0, 0, 0]);

  int xl, xr;

  bool shouldFill(int x, int y) {
    return _closeEnough(image.getPixel(x, y), oldColor);
  }

  while (q.isNotEmpty) {
    final coord = q.removeFirst();
    final x = coord[0];
    final y = coord[1];
    final parentDy = coord[2];
    final parentXl = coord[3];
    final parentXr = coord[4];

    xl = xr = x;

    // Find start of the line.
    while (xl - 1 >= 0 && shouldFill(xl - 1, y)) xl--;

    // Fill the whole line.
    for (var x = xl; x < image.width && shouldFill(x, y); x++) {
      image.setPixel(x, y, color);
      xr = x;
    }

    // Scan for new lines above.
    if (parentDy == -1) {
      if (xl < parentXl) _scanLine(xl, parentXl, y - 1, shouldFill, q, 1);
      if (xr > parentXr) _scanLine(parentXr, xr, y - 1, shouldFill, q, 1);
    } else if (y > 0) {
      _scanLine(xl, xr, y - 1, shouldFill, q, 1);
    }

    // Scan for new lines below.
    if (parentDy == 1) {
      if (xl < parentXl) _scanLine(xl, parentXl, y + 1, shouldFill, q, -1);
      if (xr > parentXr) _scanLine(parentXr, xr, y + 1, shouldFill, q, -1);
    } else if (y < image.height - 1) {
      _scanLine(xl, xr, y + 1, shouldFill, q, -1);
    }
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
  int parentDy,
) {
  bool streak = false;

  for (var x = xl; x <= xr; x++) {
    if (!streak && shouldFill(x, y)) {
      q.add([x, y, parentDy, xl, xr]);
      streak = true;
    } else if (streak && !shouldFill(x, y)) {
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
