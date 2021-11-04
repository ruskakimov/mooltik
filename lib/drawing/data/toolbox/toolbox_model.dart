import 'package:flutter/material.dart';
import 'package:mooltik/common/data/extensions/color_methods.dart';
import 'package:mooltik/drawing/data/toolbox/tools/bucket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

const _startHsvColor = HSVColor.fromAHSV(1, 0, 0, 0);

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences,
        _bucket = Bucket(sharedPreferences),
        _paintBrush = PaintBrush(sharedPreferences),
        _eraser = Eraser(sharedPreferences),
        _lasso = Lasso(sharedPreferences),
        _hsvColor = restoreHSVColorState(sharedPreferences),
        _palette = List.filled(90, null) {
    _selectedTool = _paintBrush;
    _applyColorOnTools();
  }

  final SharedPreferences _preferences;

  Color get color => _hsvColor.toColor();
  HSVColor get hsvColor => _hsvColor;
  HSVColor _hsvColor;

  List<HSVColor?> get palette => _palette;
  final List<HSVColor?> _palette;

  void fillPaletteCellWithCurrentColor(int cellIndex) {
    _palette[cellIndex] = _hsvColor;
    notifyListeners();
    // TODO: Persist
  }

  void emptyPaletteCell(int cellIndex) {
    _palette[cellIndex] = null;
    notifyListeners();
    // TODO: Persist
  }

  List<Tool> get tools => [
        bucket,
        paintBrush,
        eraser,
        lasso,
      ];

  Bucket get bucket => _bucket;
  final Bucket _bucket;

  PaintBrush get paintBrush => _paintBrush;
  final PaintBrush _paintBrush;

  Eraser get eraser => _eraser;
  final Eraser _eraser;

  Lasso get lasso => _lasso;
  final Lasso _lasso;

  Tool? get selectedTool => _selectedTool;
  Tool? _selectedTool;

  void selectTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void changeColor(HSVColor hsvColor) {
    _hsvColor = hsvColor;
    _applyColorOnTools();
    notifyListeners();
    _preferences.setString(_hsvColorKey, _hsvColor.toStr());
  }

  void _applyColorOnTools() {
    for (final tool in tools) {
      if (tool is ToolWithColor) tool.applyColor(color);
    }
  }

  static HSVColor restoreHSVColorState(SharedPreferences sharedPreferences) {
    if (sharedPreferences.containsKey(_hsvColorKey)) {
      final raw = sharedPreferences.getString(_hsvColorKey);
      if (raw != null) return raw.parseHSVColor();
    }
    return _startHsvColor;
  }

  static const String _hsvColorKey = 'hsv_color';
}
