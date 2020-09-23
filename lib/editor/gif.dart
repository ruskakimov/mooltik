import 'dart:ui' as ui;

import 'package:image/image.dart';

import 'frame/frame_model.dart';

Future<List<int>> makeGif(
  List<FrameModel> keyframes,
  int animationDuration,
) async {
  if (keyframes.isEmpty) {
    throw ArgumentError.value(keyframes, 'frames', 'should not be empty');
  }

  final encoder = GifEncoder();

  for (var i = 1; i < keyframes.length; i++) {
    final frame = keyframes[i - 1];
    final frameDuration = keyframes[i].number - frame.number;
    final img = await imageFromFrame(frame);
    encoder.addFrame(img, duration: 4 * frameDuration);
  }

  // TODO: Handle the case when frames are outside animation duration.
  final lastFrame = keyframes.last;
  final lastFrameDuration = animationDuration + 1 - lastFrame.number;
  final img = await imageFromFrame(lastFrame);
  encoder.addFrame(img, duration: 4 * lastFrameDuration);

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
  frame.paintOn(canvas);
  return recorder.endRecording();
}
