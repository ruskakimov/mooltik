import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages a stack of frame reels.
class ReelStackModel extends ChangeNotifier {
  ReelStackModel({
    @required Scene scene,
    @required SharedPreferences sharedPreferences,
  })  : _scene = scene,
        _sharedPreferences = sharedPreferences,
        _showFrameReel = sharedPreferences.getBool(_showFrameReelKey) ?? true,
        reels = scene.layers
            .map((layer) => FrameReelModel(layer.frameSeq))
            .toList();

  final Scene _scene;
  SharedPreferences _sharedPreferences;

  final List<FrameReelModel> reels;

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
    reels.insert(_activeReelIndex, FrameReelModel(layer.frameSeq));
    notifyListeners();
  }
}

const _showFrameReelKey = 'frame_reel_visible';
