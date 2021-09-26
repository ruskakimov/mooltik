import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

abstract class TimelineRowInterface {
  int get clipCount;
  Iterable<TimeSpan> get clips;

  TimeSpan clipAt(int index);
  void deleteAt(int index);
  Future<void> duplicateAt(int index);
  void changeDurationAt(int index, Duration newDuration);
  Duration startTimeOf(int index);
  Duration endTimeOf(int index);
}

abstract class TimelineSceneLayerInterface implements TimelineRowInterface {
  @override
  Iterable<FrameInterface> get clips;

  /// Apply the [playMode] to get a frame sequence that lasts [totalDuration].
  Iterable<FrameInterface> getPlayFrames(Duration totalDuration);

  PlayMode get playMode;
  void changePlayMode();

  bool get visible;
  void toggleVisibility();

  void changeAllFramesDuration(Duration newFrameDuration);

  @override
  FrameInterface clipAt(int index);
}
