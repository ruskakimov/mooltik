import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/bucket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

const _startHsvColor = HSVColor.fromAHSV(1, 0, 0, 0);

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : _bucket = Bucket(sharedPreferences),
        _paintBrush = PaintBrush(sharedPreferences),
        _eraser = Eraser(sharedPreferences),
        _lasso = Lasso(sharedPreferences),
        _hsvColor = _startHsvColor {
    _selectedTool = _paintBrush;
    // TODO: Persist color
    // _hsvColor = sharedPreferences.containsKey(_hsvColorKey)
    //     ? sharedPreferences.getString(_hsvColorKey)
    //     : _startHsvColor;
  }

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
  }

  static const String _hsvColorKey = 'hsv_color';
}
