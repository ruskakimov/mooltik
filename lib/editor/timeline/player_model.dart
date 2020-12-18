import 'package:flutter/material.dart';

class PlayerModel extends ChangeNotifier {
  bool get recording => _recording;
  bool _recording = false;
}
