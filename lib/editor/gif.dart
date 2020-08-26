import 'package:image/image.dart';

import 'frame/frame.dart';

List<int> makeGif(List<Frame> frames, int fps) {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }

  final encoder = GifEncoder(delay: 1000 ~/ fps);

  frames.forEach((frame) => encoder.addFrame(frameToImage(frame)));

  return encoder.finish();
}

Image frameToImage(Frame frame) {}
