import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Tool extends ChangeNotifier {
  Tool(this.sharedPreferences) : assert(sharedPreferences != null);

  /// Icon diplayed on the tool's button.
  IconData get icon;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  final SharedPreferences sharedPreferences;
}
