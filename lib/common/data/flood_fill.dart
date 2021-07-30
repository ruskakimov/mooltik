import 'dart:typed_data';
import 'dart:ui';

import 'package:mooltik/common/data/extensions/color_methods.dart';
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
  Color color,
) {
  FFIBridge().floodFill(
    imageBytes.buffer.asUint32List(),
    imageWidth,
    imageHeight,
    startX,
    startY,
    color.toABGR(),
  );
  return imageBytes;
}
