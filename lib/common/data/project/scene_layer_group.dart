import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline_scene_layer_interface.dart';

class SceneLayerGroup implements TimelineSceneLayerInterface {
  SceneLayerGroup(this.layers) : assert(isGroupSynced(layers));

  final List<SceneLayer> layers;

  int get realFrameCount => layers.first.realFrameCount;

  Iterable<FrameInterface> get realFrames => _combineFrameSequences(
        layers.map((layer) => layer.realFrames),
      );

  PlayMode get playMode => layers.first.playMode;

  void changePlayMode() {
    layers.forEach((layer) => layer.changePlayMode());
  }

  bool get visible => layers.any((layer) => layer.visible);

  void toggleVisibility() {
    layers.forEach((layer) => layer.setVisibility(!visible));
  }

  Iterable<FrameInterface> getPlayFrames(Duration totalDuration) =>
      _combineFrameSequences(
        layers.map((layer) => layer.getPlayFrames(totalDuration)),
      );

  void deleteAt(int realFrameIndex) {
    layers.forEach((layer) => layer.deleteAt(realFrameIndex));
  }

  Future<void> duplicateAt(int realFrameIndex) async {
    await Future.wait(layers.map((layer) => layer.duplicateAt(realFrameIndex)));
  }

  void changeDurationAt(int realFrameIndex, Duration newDuration) {
    layers.forEach(
      (layer) => layer.changeDurationAt(realFrameIndex, newDuration),
    );
  }

  void changeAllFramesDuration(Duration newFrameDuration) {
    layers.forEach((layer) => layer.changeAllFramesDuration(newFrameDuration));
  }

  Duration startTimeOf(int realFrameIndex) =>
      layers.first.startTimeOf(realFrameIndex);

  Duration endTimeOf(int realFrameIndex) =>
      layers.first.endTimeOf(realFrameIndex);
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
