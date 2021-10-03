import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/layer_group/frame_reel_group.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';

/// Manages a stack of frame reels.
class ReelStackModel extends ChangeNotifier {
  ReelStackModel({required Scene scene})
      : _scene = scene,
        reels = scene.layers
            .map((layer) => FrameReelModel(frameSeq: layer.frameSeq))
            .toList();

  final Scene _scene;
  final List<FrameReelModel> reels;

  List<SceneLayer> get _layers => _scene.layers;

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

  Future<void> addLayerAboveActive(SceneLayer layer) async {
    _layers.insert(_activeReelIndex, layer);
    reels.insert(_activeReelIndex, FrameReelModel(frameSeq: layer.frameSeq));

    // Add to group if inserting between group members.
    if (isGroupedWithAbove(_activeReelIndex)) {
      // No longer synced.
      _layers[_activeReelIndex - 1].setGroupedWithNext(false);

      await groupLayerWithAbove(_activeReelIndex);
      await groupLayerWithBelow(_activeReelIndex);
    }
    notifyListeners();
  }

  bool get canDeleteLayer => reels.length > 1;

  void deleteLayer(int layerIndex) {
    if (!canDeleteLayer) return;
    if (layerIndex < 0 || layerIndex >= reels.length) return;

    if (isGroupedWithAbove(layerIndex) && !isGroupedWithBelow(layerIndex)) {
      final above = _layers[layerIndex - 1];
      above.setGroupedWithNext(false);
    }

    reels.removeAt(layerIndex);
    final removedLayer = _layers.removeAt(layerIndex);

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
    if (oldIndex == newIndex) return;

    final activeLayerBefore = _layers[_activeReelIndex];

    final movedLayerGroup = groupInfoOf(oldIndex);

    final movingOutOfGroup =
        movedLayerGroup != null && !movedLayerGroup.contains(newIndex);

    if (movingOutOfGroup) ungroupLayer(oldIndex);

    final reel = reels.removeAt(oldIndex);
    reels.insert(newIndex, reel);

    final layer = _layers.removeAt(oldIndex);
    _severTopTie(newIndex);
    _layers.insert(newIndex, layer);

    final movedWithinGroup =
        movedLayerGroup != null && movedLayerGroup.contains(newIndex);

    if (movedWithinGroup) _fixGroupTies(movedLayerGroup!);

    _activeReelIndex = _layers.indexOf(activeLayerBefore);

    notifyListeners();
  }

  bool isVisible(int layerIndex) => _layers[layerIndex].visible;

  void setLayerVisibility(int layerIndex, bool value) {
    _layers[layerIndex].setVisibility(value);
    notifyListeners();
  }

  String getLayerName(int layerIndex) => _layers[layerIndex].name ?? 'Untitled';

  void setLayerName(int layerIndex, String value) {
    _layers[layerIndex].setName(value);
    notifyListeners();
  }

  // ============
  // Group state:
  // ============

  List<LayerGroupInfo> get layerGroups => _scene.layerGroups;

  LayerGroupInfo? groupInfoOf(int layerIndex) {
    if (!isGrouped(layerIndex)) return null;

    return layerGroups
        .firstWhere((groupInfo) => groupInfo.contains(layerIndex));
  }

  List<FrameReelModel> reelGroupOf(int layerIndex) {
    final groupInfo = groupInfoOf(layerIndex);

    if (groupInfo == null) {
      return [reels[layerIndex]];
    }

    return reels.sublist(
      groupInfo.firstLayerIndex,
      groupInfo.lastLayerIndex + 1,
    );
  }

  List<SceneLayer> layerGroupOf(int layerIndex) {
    final groupInfo = groupInfoOf(layerIndex);

    if (groupInfo == null) {
      return [_layers[layerIndex]];
    }

    return _layers.sublist(
      groupInfo.firstLayerIndex,
      groupInfo.lastLayerIndex + 1,
    );
  }

  bool isGrouped(int layerIndex) =>
      isGroupedWithAbove(layerIndex) || isGroupedWithBelow(layerIndex);

  bool isGroupedWithAbove(int layerIndex) =>
      layerIndex > 0 && _layers[layerIndex - 1].groupedWithNext;

  bool isGroupedWithBelow(int layerIndex) =>
      _layers[layerIndex].groupedWithNext;

  bool canGroupWithAbove(int layerIndex) =>
      layerIndex > 0 && !isGroupedWithAbove(layerIndex);

  bool canGroupWithBelow(int layerIndex) =>
      layerIndex < _layers.length - 1 && !isGroupedWithBelow(layerIndex);

  Future<void> groupLayerWithAbove(int layerIndex) async {
    if (layerIndex == 0) throw Exception('Cannot group first layer with above');
    await groupLayerWithBelow(layerIndex - 1);
  }

  Future<void> groupLayerWithBelow(int layerIndex) async {
    if (layerIndex == _layers.length - 1)
      throw Exception('Cannot group last layer with below');

    final aIndex = layerIndex;
    final bIndex = layerIndex + 1;

    final aGroupLayers = layerGroupOf(aIndex);
    final bGroupLayers = layerGroupOf(bIndex);
    await mergeGroups(aGroupLayers, bGroupLayers);

    final a = _layers[aIndex];
    a.setGroupedWithNext(true);

    // Sync current frames in B to A.
    reelGroupOf(bIndex).forEach(
      (reel) => reel.setCurrent(reels[aIndex].currentIndex),
    );

    notifyListeners();
  }

  void ungroupLayer(int layerIndex) {
    _severTopTie(layerIndex);
    _severBottomTie(layerIndex);
    notifyListeners();
  }

  void _severTopTie(int layerIndex) {
    if (layerIndex > 0) _layers[layerIndex - 1].setGroupedWithNext(false);
  }

  void _severBottomTie(int layerIndex) {
    _layers[layerIndex].setGroupedWithNext(false);
  }

  void _fixGroupTies(LayerGroupInfo groupInfo) {
    for (int i = groupInfo.firstLayerIndex;
        i <= groupInfo.lastLayerIndex;
        i++) {
      _layers[i].setGroupedWithNext(i != groupInfo.lastLayerIndex);
    }
  }
}
