import 'dart:typed_data';

import 'package:mooltik/ffi_bridge.dart';

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
  FFIBridge().floodFill(
    imageBytes.buffer.asUint32List(),
    _color(0, 255, 0, 255),
  );
  return imageBytes;
}

int _color(int r, int g, int b, int a) {
  return [a, b, g, r].reduce((result, channel) => result << 8 | channel);
}
