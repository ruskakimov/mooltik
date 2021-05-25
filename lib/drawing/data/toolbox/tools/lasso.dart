import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Lasso extends Tool {
  Lasso(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.lasso;

  @override
  String get name => 'lasso';

  void startSelection(Offset framePoint) {
    print(framePoint);
  }

  void updateSelection(Offset framePoint) {
    print(framePoint);
  }

  void finishSelection() {
    print('finish');
  }
}
