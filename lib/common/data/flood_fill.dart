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

  final ov = image.getPixel(startX, startY);

  // Whether the pixel is unfilled and inside the fill area. Returns false for filled pixels.
  bool inside(int x, int y) =>
      image.withinBounds(x, y) &&
      _closeEnough(
        image.getPixel(x, y),
        ov,
      );

  // Prevent infinite loop. Not neccessary when filled area is written to an empty image.
  if (!inside(startX, startY)) return imageBytes;

  final nv = color;
  int x = startX;
  int y = startY;
  int l = 0, x1, x2, dy;

  final s = Queue<List<int>>();

  // Based on:
  // https://github.com/erich666/GraphicsGems/blob/8ffc343ad959c134a36bbbcee46b5d82f676c92d/gems/SeedFill.c
  // PUSH(y, x, x, 1); /* needed in some cases */
  s.add([y, x, x, 1]);
  // PUSH(y + 1, x, x, -1); /* seed segment (popped 1st) */
  s.add([y + 1, x, x, -1]);

  while (s.isNotEmpty) {
    // #define POP(Y, XL, XR, DY)	/* pop segment off stack */ \
    // {sp--; Y = sp->y+(DY = sp->dy); XL = sp->xl; XR = sp->xr;}
    // POP(y, x1, x2, dy);
    final coord = s.removeLast();
    dy = coord[3];
    y = coord[0] + dy;
    x1 = coord[1];
    x2 = coord[2];

    // for (x=x1; x>=win->x0 && pixelread(x, y)==ov; x--)
    //   pixelwrite(x, y, nv);
    for (x = x1; x >= 0 && image.getPixel(x, y) == ov; x--)
      image.setPixel(x, y, nv);

    //   if (x>=x1) goto skip;
    //   l = x+1;
    //   if (l<x1) PUSH(y, l, x1-1, -dy);		/* leak on left? */
    //   x = x1+1;
    //   do {
    //       for (; x<=win->x1 && pixelread(x, y)==ov; x++)
    //         pixelwrite(x, y, nv);
    //       PUSH(y, l, x-1, dy);
    //       if (x>x2+1) PUSH(y, x2+1, x-1, -dy);	/* leak on right? */
    // skip: for (x++; x<=x2 && pixelread(x, y)!=ov; x++);
    //       l = x;
    //   } while (x<=x2);

    bool skip = x >= x1;
    if (!skip) {
      l = x + 1;
      if (l < x1) s.add([y, l, x1 - 1, -dy]);
      x = x1 + 1;
    }

    do {
      if (!skip) {
        for (; x < image.width && image.getPixel(x, y) == ov; x++)
          image.setPixel(x, y, nv);
        s.add([y, l, x - 1, dy]);
        if (x > x2 + 1) s.add([y, x2 + 1, x - 1, -dy]);
        skip = false;
      }
      for (x++; x <= x2 && image.getPixel(x, y) != ov; x++);
      l = x;
    } while (x <= x2);
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
