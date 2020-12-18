import 'package:flutter/material.dart';

class PlayerModel extends ChangeNotifier {
  bool get recording => _recording;
  bool _recording = false;

  void startRecording() {
    _recording = true;
    notifyListeners();
  }

  void stopRecording() {
    _recording = false;
    notifyListeners();
  }
}
