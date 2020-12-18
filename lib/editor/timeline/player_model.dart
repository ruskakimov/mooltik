import 'package:flutter/material.dart';
import 'package:mooltik/editor/sound_bite.dart';

class PlayerModel extends ChangeNotifier {
  bool get isRecording => _isRecording;
  bool _isRecording = false;

  SoundBite get soundBite => _soundBite;
  SoundBite _soundBite = SoundBite(
    startTime: Duration(seconds: 1),
    duration: Duration(seconds: 2),
  );

  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }
}
