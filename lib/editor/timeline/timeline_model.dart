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

  FrameModel createKeyframeAtSelectedNumber() {
    if (selectedKeyframe != null) return selectedKeyframe;

    final newKeyframe = FrameModel(
      selectedFrameNumber,
      initialSnapshot: visibleKeyframe.snapshot,
    );

    final index = keyframes.indexOf(visibleKeyframe);
    keyframes.insert(index + 1, newKeyframe);

    _visibleKeyframe = newKeyframe;
    notifyListeners();

    return newKeyframe;
  }

  void deleteSelectedKeyframe() {
    if (selectedKeyframe == null) return;

    keyframes.remove(selectedKeyframe);
    _updateVisibleKeyframe();

    notifyListeners();
  }

  void _updateVisibleKeyframe() {
    _visibleKeyframe = keyframes
        .lastWhere((keyframe) => keyframe.number <= _selectedFrameNumber);
  }
}
