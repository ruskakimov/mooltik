import 'package:flutter/material.dart';

import 'frame/frame.dart';

class Timeline extends ChangeNotifier {
  List<Frame> frames = [Frame()];
  int _selectedFrameIndex = 0;

  Frame get selectedFrame => frames[_selectedFrameIndex];
}
