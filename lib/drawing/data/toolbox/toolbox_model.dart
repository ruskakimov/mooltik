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
        _hsvColor = restoreHSVColorState(sharedPreferences) {
    _selectedTool = _paintBrush;
  }

  final SharedPreferences _preferences;

  Color get color => _hsvColor.toColor();
  HSVColor get hsvColor => _hsvColor;
  HSVColor _hsvColor;

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
    notifyListeners();
    _preferences.setString(_hsvColorKey, _hsvColor.toStr());
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
