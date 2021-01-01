import 'package:flutter/material.dart';

class ExporterModel extends ChangeNotifier {
  /// Value between 0 and 1 that indicates video export progress.
  /// 0 - export hasn't began
  /// 1 - video exported successfully.
  double get progress => _progress;
  double _progress = 0;

  bool get hasntBegan => _progress == 0;
}
