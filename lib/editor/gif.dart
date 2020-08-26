import 'frame/frame.dart';

List<int> makeGif(List<Frame> frames, int fps) {
  if (frames.isEmpty) {
    throw ArgumentError.value(frames, 'frames', 'should not be empty');
  }
}
