import 'package:flutter/material.dart';

class PlayerModel extends ChangeNotifier {
  bool get isRecording => _isRecording;
  bool _isRecording = false;

  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }
}
