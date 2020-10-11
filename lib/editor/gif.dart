import 'dart:ui' as ui;

import 'package:image/image.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

import 'frame/frame_model.dart';

Future<List<int>> makeGif(List<FrameModel> frames, List<int> durations) async {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }

  final encoder = GifEncoder(samplingFactor: 1000);

  for (int i = 0; i < frames.length; i++) {
    if (frames[i] == null) continue;
    final img = await imageFromFrame(frames[i]);
    encoder.addFrame(img, duration: 4 * durations[i]);
  }

  return encoder.finish();
}

Future<Image> imageFromFrame(FrameModel frame) async {
  final w = frame.width.toInt();
  final h = frame.height.toInt();

  final pic = pictureFromFrame(frame);
  final img = await pic.toImage(w, h);
  final byteData = await img.toByteData();
  final bytes = byteData.buffer.asUint32List();

  return Image.fromBytes(w, h, bytes);
}

ui.Picture pictureFromFrame(FrameModel frame) {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  FramePainter(frame: frame).paint(canvas, ui.Size(frame.width, frame.height));
  return recorder.endRecording();
}
