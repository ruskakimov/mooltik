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
  for (int x = 0; x < imageWidth; x++) {
    for (int y = 0; y < imageHeight; y++) {
      final byteOffset = (y * imageWidth + x) * 4;
      imageBytes.setUint32(byteOffset, color);
    }
  }
  return imageBytes;
}
