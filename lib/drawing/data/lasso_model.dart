import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';

class LassoModel extends ChangeNotifier {
  LassoModel(EaselModel easel) : _easel = easel;

  EaselModel _easel;

  void updateEasel(EaselModel easel) {
    _easel = easel;
    notifyListeners();
  }
}
