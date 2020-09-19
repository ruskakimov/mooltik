import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  List<FrameModel> frames = [FrameModel()];
  int _selectedFrameIndex = 0;

  FrameModel get selectedFrame => frames[_selectedFrameIndex];
}
