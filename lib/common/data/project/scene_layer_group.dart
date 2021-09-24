import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';

class SceneLayerGroup implements SceneLayer {
  SceneLayerGroup(this.layers);

  final Iterable<SceneLayer> layers;

  @override
  // TODO: implement frameSeq
  Sequence<Frame> get frameSeq => throw UnimplementedError();

  @override
  // TODO: Return composite frame
  Frame frameAt(Duration playhead) {
    // TODO: implement frameAt
    throw UnimplementedError();
  }

  @override
  // TODO: Return composite frames
  Iterable<Frame> getExportFrames(Duration totalDuration) {
    // TODO: implement getExportFrames
    throw UnimplementedError();
  }

  @override
  // TODO: Return composite frames
  Iterable<Frame> getGhostFrames(Duration totalDuration) {
    // TODO: implement getGhostFrames
    throw UnimplementedError();
  }

  @override
  // TODO: implement playMode
  PlayMode get playMode => throw UnimplementedError();

  @override
  void nextPlayMode() {
    // TODO: implement nextPlayMode
    throw UnimplementedError();
  }

  @override
  void setPlayMode(PlayMode value) {
    // TODO: implement setPlayMode
    throw UnimplementedError();
  }

  @override
  // TODO: implement visible
  bool get visible => throw UnimplementedError();

  @override
  void setVisibility(bool value) {
    // TODO: implement setVisibility
    throw UnimplementedError();
  }

  @override
  String? get name =>
      throw UnsupportedError('Refer to individual layers instead.');

  @override
  void setName(String value) =>
      throw UnsupportedError('Rename individual layers instead.');

  @override
  bool get groupedWithNext =>
      throw UnsupportedError('Refer to individual layers instead.');

  @override
  void setGroupedWithNext(bool value) =>
      throw UnsupportedError('Group individual layers instead.');

  @override
  Future<SceneLayer> duplicate() =>
      throw UnsupportedError('Duplicate individual layers instead.');

  @override
  Map<String, dynamic> toJson() =>
      throw UnsupportedError('Group relationships are stored separately.');

  @override
  void dispose() =>
      throw UnsupportedError('Dispose individual layers instead.');
}
