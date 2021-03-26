import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _visibleKey = 'frame_reel_visible';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences,
        _visible = sharedPreferences.getBool(_visibleKey) ?? true;

  SharedPreferences _preferences;

  bool get visible => _visible;
  bool _visible;

  Future<void> toggleVisibility() async {
    _visible = !_visible;
    notifyListeners();

    await _preferences.setBool(_visibleKey, _visible);
  }
}
