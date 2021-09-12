import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/layer_group/frame_reel_group.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';

/// Manages a stack of frame reels.
class ReelStackModel extends ChangeNotifier {
  ReelStackModel({
    required Scene scene,
    required CreateNewFrame createNewFrame,
  })  : _scene = scene,
        _createNewFrame = createNewFrame,
        reels = scene.layers
            .map((layer) => FrameReelModel(
                  frameSeq: layer.frameSeq,
                  createNewFrame: createNewFrame,
                ))
            .toList();

  final Scene _scene;
  final CreateNewFrame _createNewFrame;

  final List<FrameReelModel> reels;

  Iterable<FrameReelModel> get visibleReels => reels
      .where((reel) => isVisible(reels.indexOf(reel)) || reel == activeReel);

  bool isActive(int layerIndex) => _activeReelIndex == layerIndex;

  FrameReelModel get activeReel => isGrouped(_activeReelIndex)
      ? FrameReelGroup(
          activeReel: reels[_activeReelIndex],
          group: reelGroupOf(_activeReelIndex),
        )
      : reels[_activeReelIndex];

  int get activeReelIndex => _activeReelIndex;
  int _activeReelIndex = 0;

  void setActiveReelIndex(int index) {
    _activeReelIndex = index.clamp(0, reels.length - 1);
    notifyListeners();
  }

  void changeActiveReel(FrameReelModel reel) {
    final index = reels.indexOf(reel);
    setActiveReelIndex(index);
  }

  void addLayerAboveActive(SceneLayer layer) {
    _scene.layers.insert(_activeReelIndex, layer);
    reels.insert(
        _activeReelIndex,
        FrameReelModel(
          frameSeq: layer.frameSeq,
          createNewFrame: _createNewFrame,
        ));
    notifyListeners();
  }

  bool get canDeleteLayer => reels.length > 1;

  void deleteLayer(int layerIndex) {
    if (!canDeleteLayer) return;
    if (layerIndex < 0 || layerIndex >= reels.length) return;

    reels.removeAt(layerIndex);
    final removedLayer = _scene.layers.removeAt(layerIndex);

    Future.delayed(
      Duration(seconds: 1),
      () => removedLayer.dispose(),
    );

    setActiveReelIndex(
      layerIndex < _activeReelIndex ? _activeReelIndex - 1 : _activeReelIndex,
    );
    notifyListeners();
  }

  void onLayerReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final activeReelBefore = activeReel;

    final reel = reels.removeAt(oldIndex);
    reels.insert(newIndex, reel);

    final layer = _scene.layers.removeAt(oldIndex);
    _scene.layers.insert(newIndex, layer);

    _activeReelIndex = reels.indexOf(activeReelBefore);

    notifyListeners();
  }

  bool isVisible(int layerIndex) => _scene.layers[layerIndex].visible;

  void setLayerVisibility(int layerIndex, bool value) {
    _scene.layers[layerIndex].setVisibility(value);
    notifyListeners();
  }

  String getLayerName(int layerIndex) =>
      _scene.layers[layerIndex].name ?? 'Untitled';

  void setLayerName(int layerIndex, String value) {
    _scene.layers[layerIndex].setName(value);
    notifyListeners();
  }

  // ============
  // Group state:
  // ============

  List<LayerGroupInfo> get layerGroups => _scene.layerGroups;

  List<FrameReelModel> reelGroupOf(int layerIndex) {
    if (!isGrouped(layerIndex)) return [reels[layerIndex]];

    final groupInfo = layerGroups.firstWhere((groupInfo) =>
        groupInfo.firstLayerIndex <= layerIndex &&
        layerIndex <= groupInfo.lastLayerIndex);

    return reels.sublist(
      groupInfo.firstLayerIndex,
      groupInfo.lastLayerIndex + 1,
    );
  }

  List<SceneLayer> layerGroupOf(int layerIndex) {
    if (!isGrouped(layerIndex)) return [_scene.layers[layerIndex]];

    final groupInfo = layerGroups.firstWhere((groupInfo) =>
        groupInfo.firstLayerIndex <= layerIndex &&
        layerIndex <= groupInfo.lastLayerIndex);

    return _scene.layers.sublist(
      groupInfo.firstLayerIndex,
      groupInfo.lastLayerIndex + 1,
    );
  }

  bool isGrouped(int layerIndex) =>
      isGroupedWithAbove(layerIndex) || isGroupedWithBelow(layerIndex);

  bool isGroupedWithAbove(int layerIndex) =>
      layerIndex > 0 && _scene.layers[layerIndex - 1].groupedWithNext;

  bool isGroupedWithBelow(int layerIndex) =>
      _scene.layers[layerIndex].groupedWithNext;

  bool canGroupWithAbove(int layerIndex) =>
      layerIndex > 0 && !isGroupedWithAbove(layerIndex);

  bool canGroupWithBelow(int layerIndex) =>
      layerIndex < _scene.layers.length - 1 && !isGroupedWithBelow(layerIndex);

  Future<void> groupLayerWithAbove(int layerIndex) async {
    if (layerIndex == 0) throw Exception('Cannot group first layer with above');
    await groupLayerWithBelow(layerIndex - 1);
  }

  Future<void> groupLayerWithBelow(int layerIndex) async {
    if (layerIndex == _scene.layers.length - 1)
      throw Exception('Cannot group last layer with below');

    final aIndex = layerIndex;
    final bIndex = layerIndex + 1;

    final aGroupLayers = layerGroupOf(aIndex);
    final bGroupLayers = layerGroupOf(bIndex);
    await mergeGroups(aGroupLayers, bGroupLayers);

    final a = _scene.layers[aIndex];
    a.setGroupedWithNext(true);

    // Sync current frames in B to A.
    reelGroupOf(bIndex).forEach(
      (reel) => reel.setCurrent(reels[aIndex].currentIndex),
    );

    notifyListeners();
  }

  void ungroupLayer(int layerIndex) {
    if (layerIndex > 0) _scene.layers[layerIndex - 1].setGroupedWithNext(false);
    _scene.layers[layerIndex].setGroupedWithNext(false);
    notifyListeners();
  }
}
