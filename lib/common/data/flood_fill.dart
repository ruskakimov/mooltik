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
    color,
  );
  return imageBytes;
}
