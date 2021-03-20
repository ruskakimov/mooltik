import 'package:flutter/material.dart';

class FrameReelModel extends ChangeNotifier {
  bool get visible => _visible;
  bool _visible = false;

  void toggleVisibility() {
    _visible = !_visible;
    notifyListeners();
  }
}
