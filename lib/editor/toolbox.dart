import 'package:flutter/material.dart';

import 'toolbar/tools.dart';

class Toolbox extends ChangeNotifier {
  Tool _selectedTool = Pencil(strokeWidth: 5);

  Tool get selectedTool => _selectedTool;

  void selectTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }
}
