import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    TimelineModel timeline,
  }) : _timeline = timeline;

  final TimelineModel _timeline;
}
