import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingPageOptionsModel extends ChangeNotifier {
  DrawingPageOptionsModel(
    SharedPreferences sharedPreferences,
  )   : _sharedPreferences = sharedPreferences,
        _showFrameReel = sharedPreferences.getBool(_showFrameReelKey) ?? true;

  SharedPreferences _sharedPreferences;

  /// Whether frame reel UI is visible.
  bool get showFrameReel => _showFrameReel;
  bool _showFrameReel;

  Future<void> toggleFrameReelVisibility() async {
    _showFrameReel = !_showFrameReel;
    notifyListeners();
    await _sharedPreferences.setBool(_showFrameReelKey, _showFrameReel);
  }
}

const _showFrameReelKey = 'frame_reel_visible';
