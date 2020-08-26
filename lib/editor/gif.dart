import 'package:gifencoder/gifencoder.dart';

import 'frame/frame.dart';

List<int> createGif(List<Frame> frames, int fps) {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }
}
