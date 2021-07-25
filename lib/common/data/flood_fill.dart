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

  final startCoord = _Coord(startX, startY);
  final startColor = image.getPixel(startCoord);

  final q = Queue<_Coord>();
  q.add(startCoord);

  while (q.isNotEmpty) {
    final coord = q.removeFirst();

    if (!image.withinBounds(coord)) continue;

    final pixelColor = image.getPixel(coord);

    if (_closeEnough(startColor, pixelColor)) {
      image.setPixel(coord, color);
      q.add(_Coord(coord.x + 1, coord.y));
      q.add(_Coord(coord.x - 1, coord.y));
      q.add(_Coord(coord.x, coord.y + 1));
      q.add(_Coord(coord.x, coord.y - 1));
    }
  }

  return image.bytes;
}

bool _closeEnough(int originalColor, int pixelColor) {
  return (originalColor - pixelColor).abs() < 5;
}

class _Coord {
  _Coord(this.x, this.y);

  final int x;
  final int y;
}

class _Image {
  _Image(this.bytes, this.width, this.height);

  final ByteData bytes;
  final int width;
  final int height;

  bool withinBounds(_Coord coord) {
    return coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height;
  }

  int _byteOffset(_Coord coord) => (coord.y * width + coord.x) * 4;

  int getPixel(_Coord coord) {
    return bytes.getUint32(_byteOffset(coord));
  }

  void setPixel(_Coord coord, int color) {
    return bytes.setUint32(_byteOffset(coord), color);
  }
}
