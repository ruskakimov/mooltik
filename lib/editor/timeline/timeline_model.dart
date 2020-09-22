import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  List<FrameModel> frames = [FrameModel()];
  int _selectedFrameIndex = 0;

  int _frameNumber = 1;

  int get selectedFrameNumber => _frameNumber;

  FrameModel get selectedFrame => frames[_selectedFrameIndex];

  void selectFrame(int number) {
    assert(number > 0);
    _frameNumber = number;
    notifyListeners();
  }
}
