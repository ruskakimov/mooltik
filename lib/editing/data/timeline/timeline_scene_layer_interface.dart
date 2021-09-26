import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/editing/data/timeline/timeline_row_interface.dart';

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
