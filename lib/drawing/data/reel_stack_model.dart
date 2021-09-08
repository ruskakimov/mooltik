import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages a stack of frame reels.
class ReelStackModel extends ChangeNotifier {
  ReelStackModel({
    required Scene scene,
    required SharedPreferences sharedPreferences,
    required CreateNewFrame createNewFrame,
  })  : _scene = scene,
        _sharedPreferences = sharedPreferences,
        _createNewFrame = createNewFrame,
        _showFrameReel = sharedPreferences.getBool(_showFrameReelKey) ?? true,
        reels = scene.layers
            .map((layer) => FrameReelModel(
                  frameSeq: layer.frameSeq,
                  createNewFrame: createNewFrame,
                ))
            .toList();

  final Scene _scene;
  SharedPreferences _sharedPreferences;
  final CreateNewFrame _createNewFrame;

  final List<FrameReelModel> reels;

  Iterable<FrameReelModel> get visibleReels => reels
      .where((reel) => isVisible(reels.indexOf(reel)) || reel == activeReel);

  FrameReelModel get activeReel => reels[_activeReelIndex];
  int _activeReelIndex = 0;

  void changeActiveReel(FrameReelModel reel) {
    final index = reels.indexOf(reel);
    if (index != -1) {
      _activeReelIndex = index;
      notifyListeners();
    }
  }

  /// Whether frame reel UI is visible.
  bool get showFrameReel => _showFrameReel;
  bool _showFrameReel;

  Future<void> toggleFrameReelVisibility() async {
    _showFrameReel = !_showFrameReel;
    notifyListeners();
    await _sharedPreferences.setBool(_showFrameReelKey, _showFrameReel);
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

    final activeReelBefore = activeReel;

    reels.removeAt(layerIndex);
    final removedLayer = _scene.layers.removeAt(layerIndex);

    Future.delayed(
      Duration(seconds: 1),
      () => removedLayer.dispose(),
    );

    if (layerIndex == _activeReelIndex) {
      _activeReelIndex = _activeReelIndex.clamp(0, reels.length - 1);
    } else {
      _activeReelIndex = reels.indexOf(activeReelBefore);
    }
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

  bool isGrouped(int layerIndex) =>
      _scene.layers[layerIndex].groupedWithNext ||
      layerIndex > 0 && _scene.layers[layerIndex - 1].groupedWithNext;

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
}

const _showFrameReelKey = 'frame_reel_visible';
