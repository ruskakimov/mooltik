import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _visibleKey = 'frame_reel_visible';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel({
    @required this.frames,
    @required SharedPreferences sharedPreferences,
  })  : _preferences = sharedPreferences,
        _currentIndex = frames.currentIndex,
        _visible = sharedPreferences.getBool(_visibleKey) ?? true;

  SharedPreferences _preferences;

  bool get visible => _visible;
  bool _visible;

  Future<void> toggleVisibility() async {
    _visible = !_visible;
    notifyListeners();

    await _preferences.setBool(_visibleKey, _visible);
  }

  final Sequence<FrameModel> frames;

  FrameModel get currentFrame => frames[_currentIndex];

  int get currentIndex => _currentIndex;
  int _currentIndex;

  void setCurrent(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
