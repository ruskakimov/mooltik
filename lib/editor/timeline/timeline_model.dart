import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  List<FrameModel> keyframes = [FrameModel()];
  int _selectedFrameIndex = 0;

  int _selectedFrameNumber = 1;

  int get selectedFrameNumber => _selectedFrameNumber;

  FrameModel get selectedFrame => keyframes[_selectedFrameIndex];

  void selectFrame(int number) {
    assert(number > 0);
    _selectedFrameNumber = number;
    notifyListeners();
  }
}
