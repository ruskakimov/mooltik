import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';

abstract class TimelineSceneLayerInterface {
  int get realFrameCount;
  Iterable<FrameInterface> get realFrames;

  PlayMode get playMode;
  void changePlayMode();

  bool get visible;
  void toggleVisibility();

  /// Apply the [playMode] to get a frame sequence that lasts [totalDuration].
  Iterable<FrameInterface> getPlayFrames(Duration totalDuration);

  void deleteAt(int realFrameIndex);
  Future<void> duplicateAt(int realFrameIndex);
  void changeDurationAt(int realFrameIndex, Duration newDuration);
  void changeAllFramesDuration(Duration newFrameDuration);
  Duration startTimeOf(int realFrameIndex);
  Duration endTimeOf(int realFrameIndex);
}
