import 'package:flutter/material.dart';

import 'frame/frame.dart';
import 'toolbar/tools.dart';

class EditorModel extends ChangeNotifier {
  List<Frame> frames = [Frame()];
  int _selectedFrameIndex = 0;

  Tool _selectedTool = Pencil(strokeWidth: 5);

  Frame get selectedFrame => frames[_selectedFrameIndex];
  Tool get selectedTool => _selectedTool;

  void selectTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }
}
