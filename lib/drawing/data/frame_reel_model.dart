import 'package:flutter/material.dart';

class FrameReelModel extends ChangeNotifier {
  bool get open => _open;
  bool _open = false;

  void toggleVisibility() {
    _open = !_open;
    notifyListeners();
  }
}
