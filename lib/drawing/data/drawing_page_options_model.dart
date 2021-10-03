import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingPageOptionsModel extends ChangeNotifier {
  DrawingPageOptionsModel(
    SharedPreferences sharedPreferences,
  )   : _sharedPreferences = sharedPreferences,
        _showFrameReel = sharedPreferences.getBool(_showFrameReelKey) ?? true,
        _allowDrawingWithFinger =
            sharedPreferences.getBool(_allowDrawingWithFingerKey) ?? true;

  SharedPreferences _sharedPreferences;

  /// Whether frame reel UI is visible.
  bool get showFrameReel => _showFrameReel;
  bool _showFrameReel;

  Future<void> toggleFrameReelVisibility() async {
    _showFrameReel = !_showFrameReel;
    notifyListeners();
    await _sharedPreferences.setBool(_showFrameReelKey, _showFrameReel);
  }

  bool get allowDrawingWithFinger => _allowDrawingWithFinger;
  bool _allowDrawingWithFinger;

  Future<void> toggleDrawingWithFinger() async {
    _allowDrawingWithFinger = !_allowDrawingWithFinger;
    notifyListeners();

    await _sharedPreferences.setBool(
      _allowDrawingWithFingerKey,
      _allowDrawingWithFinger,
    );
  }
}

const _showFrameReelKey = 'frame_reel_visible';
const _allowDrawingWithFingerKey = 'allow_drawing_with_finger';
