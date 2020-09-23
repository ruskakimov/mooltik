import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required initialKeyframes,
  })  : assert(initialKeyframes.isNotEmpty),
        keyframes = initialKeyframes,
        _selectedFrameNumber = 1,
        _visibleKeyframe = initialKeyframes.first;

  List<FrameModel> keyframes;
  int _selectedFrameNumber = 1;
  FrameModel _visibleKeyframe;

  int get selectedFrameNumber => _selectedFrameNumber;

  FrameModel get visibleKeyframe => _visibleKeyframe;

  FrameModel get selectedKeyframe =>
      visibleKeyframe.number == selectedFrameNumber ? visibleKeyframe : null;

  void selectFrame(int number) {
    assert(number > 0);
    _selectedFrameNumber = number;
    _updateVisibleKeyframe();
    notifyListeners();
  }

  void createKeyframeAtSelectedNumber() {
    if (selectedKeyframe != null) return;
    final newKeyframe = FrameModel(selectedFrameNumber);

    final index = keyframes.indexOf(visibleKeyframe);
    keyframes.insert(index + 1, newKeyframe);

    _visibleKeyframe = newKeyframe;
    notifyListeners();
  }

  void _updateVisibleKeyframe() {
    _visibleKeyframe = keyframes
        .lastWhere((keyframe) => keyframe.number <= _selectedFrameNumber);
  }
}
