import 'dart:ui' as ui;

import 'package:image/image.dart';

import 'frame/frame.dart';

List<int> makeGif(List<Frame> frames, int fps) {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }

  final encoder = GifEncoder(delay: 1000 ~/ fps);

  frames.forEach((frame) => encoder.addFrame(imageFromFrame(frame)));

  return encoder.finish();
}

Image imageFromFrame(Frame frame) => imageFromPicture(pictureFromFrame(frame));

ui.Picture pictureFromFrame(Frame frame) {}

Image imageFromPicture(ui.Picture picture) {}
