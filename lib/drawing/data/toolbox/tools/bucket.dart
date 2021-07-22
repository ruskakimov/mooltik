import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Bucket extends ToolWithColor {
  Bucket(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.formatColorFill;

  @override
  String get name => 'bucket';
}
