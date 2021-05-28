import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';

class LassoModel extends ChangeNotifier {
  LassoModel(EaselModel easel) : _easel = easel;

  EaselModel _easel;

  void updateEasel(EaselModel easel) {
    _easel = easel;
    notifyListeners();
  }

  bool get showLassoMenu => _easel.selectedTool is Lasso && finishedSelection;

  bool get finishedSelection => _easel.selectionStroke?.finished ?? false;
}
