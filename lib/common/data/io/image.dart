import 'dart:async';
import 'dart:typed_data';

import 'dart:ui';

Future<Image> imageFromRawBytes(ByteData bytes, int width, int height) {
  final Completer<Image> completer = Completer<Image>();
  decodeImageFromPixels(
    bytes.buffer.asUint8List(),
    width,
    height,
    PixelFormat.rgba8888,
    (Image image) => completer.complete(image),
  );
  return completer.future;
}

Future<Image> imageFromFileBytes(Uint8List bytes) async {
  final codec = await instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}
