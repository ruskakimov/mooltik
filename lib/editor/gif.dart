import 'dart:ui' as ui;

import 'package:image/image.dart';

import 'frame/frame.dart';

Future<List<int>> makeGif(List<Frame> frames, int fps) async {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }

  final encoder = GifEncoder(delay: 100 ~/ fps);

  for (final frame in frames) {
    final img = await imageFromFrame(frame);
    encoder.addFrame(img);
  }

  return encoder.finish();
}

Future<Image> imageFromFrame(Frame frame) async {
  final w = frame.width.toInt();
  final h = frame.height.toInt();

  final pic = pictureFromFrame(frame);
  final img = await pic.toImage(w, h);
  final byteData = await img.toByteData();
  final bytes = byteData.buffer.asUint32List();

  return Image.fromBytes(w, h, bytes);
}

ui.Picture pictureFromFrame(Frame frame) {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  frame.paintOn(canvas);
  return recorder.endRecording();
}
