import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _sharedPreferences = sharedPreferences,
        _tools = [
          Brush(sharedPreferences),
          Pen(sharedPreferences),
          Eraser(sharedPreferences),
        ],
        _selectedToolId = 1;

  final SharedPreferences _sharedPreferences;

  final List<Tool> _tools;
  int _selectedToolId;

  List<Tool> get tools => _tools;
  Tool get selectedTool => _tools[_selectedToolId];

  void selectTool(Tool tool) {
    assert(_tools.contains(tool));
    _selectedToolId = _tools.indexOf(tool);
    notifyListeners();
  }

  double get selectedToolStrokeWidth => selectedTool?.paint?.strokeWidth;

  void changeToolStrokeWidth(double strokeWidth) {
    assert(strokeWidth <= selectedTool.maxStrokeWidth &&
        strokeWidth >= selectedTool.minStrokeWidth);

    selectedTool.paint.strokeWidth = strokeWidth;

    _sharedPreferences.setDouble(
      selectedTool.strokeWidthKey,
      strokeWidth,
    );
    notifyListeners();
  }

  double get selectedToolOpacity => selectedTool?.paint?.color?.opacity;

  void changeToolOpacity(double opacity) {
    assert(opacity >= 0 && opacity <= 1);

    selectedTool.paint.color = selectedTool.paint.color.withOpacity(opacity);

    _sharedPreferences.setInt(
      selectedTool.colorKey,
      selectedTool.paint.color.value,
    );
    notifyListeners();
  }

  /*
  Size picker state:
  */

  bool get sizePickerOpen => _sizePickerOpen;
  bool _sizePickerOpen = false;

  void openSizePicker() {
    _sizePickerOpen = true;
    notifyListeners();
  }

  void closeSizePicker() {
    _sizePickerOpen = false;
    notifyListeners();
  }
}
