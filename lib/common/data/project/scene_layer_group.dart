import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline/timeline_row_interfaces.dart';

class SceneLayerGroup implements TimelineSceneLayerInterface {
  SceneLayerGroup(List<SceneLayer> layers)
      : assert(isGroupSynced(layers)),
        _layers = layers;

  final List<SceneLayer> _layers;

  @override
  int get clipCount => _layers.first.clipCount;

  @override
  Iterable<FrameInterface> get clips => _combineFrameSequences(
        _layers.map((layer) => layer.clips),
      );

  @override
  PlayMode get playMode => _layers.first.playMode;

  @override
  void changePlayMode() {
    _layers.forEach((layer) => layer.changePlayMode());
  }

  @override
  bool get visible => _layers.any((layer) => layer.visible);

  @override
  void toggleVisibility() {
    _layers.forEach((layer) => layer.setVisibility(!visible));
  }

  @override
  Iterable<FrameInterface> getPlayFrames(Duration totalDuration) =>
      _combineFrameSequences(
        _layers.map((layer) => layer.getPlayFrames(totalDuration)),
      );

  @override
  CompositeFrame clipAt(int index) => _combineFrames(
        _layers.map((layer) => layer.clipAt(index)),
      );

  @override
  CompositeFrame deleteAt(int realFrameIndex) {
    final deleted = clipAt(realFrameIndex);
    _layers.forEach((layer) => layer.deleteAt(realFrameIndex));
    return deleted;
  }

  @override
  Future<void> duplicateAt(int realFrameIndex) async {
    await Future.wait(
        _layers.map((layer) => layer.duplicateAt(realFrameIndex)));
  }

  @override
  void changeDurationAt(int realFrameIndex, Duration newDuration) {
    _layers.forEach(
      (layer) => layer.changeDurationAt(realFrameIndex, newDuration),
    );
  }

  @override
  void changeAllFramesDuration(Duration newFrameDuration) {
    _layers.forEach((layer) => layer.changeAllFramesDuration(newFrameDuration));
  }

  @override
  Duration startTimeOf(int realFrameIndex) =>
      _layers.first.startTimeOf(realFrameIndex);

  @override
  Duration endTimeOf(int realFrameIndex) =>
      _layers.first.endTimeOf(realFrameIndex);
}

CompositeFrame _combineFrames(Iterable<Frame> frames) {
  assert(frames.isNotEmpty);
  assert(frames.every((frame) => frame.duration == frames.first.duration));

  final images = frames.map((frame) => frame.image).toList();
  return CompositeFrame(CompositeImage(images), frames.first.duration);
}

Iterable<CompositeFrame> _combineFrameSequences(
  Iterable<Iterable<Frame>> frameSequences,
) sync* {
  assert(frameSequences.isNotEmpty);

  final iterators = frameSequences.map((sequence) => sequence.iterator);

  do {
    yield _combineFrames(iterators.map((iterator) => iterator.current));
  } while (iterators.every((iterator) => iterator.moveNext()));
}
