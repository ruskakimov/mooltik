import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required initialKeyframes,
  })  : assert(initialKeyframes.isNotEmpty),
        keyframes = initialKeyframes;

  List<FrameModel> keyframes;

  int get selectedKeyframeId => _selectedKeyframeId;
  int _selectedKeyframeId = 0;

  FrameModel get selectedKeyframe => keyframes[_selectedKeyframeId];

  bool get playing => _playing;
  bool _playing = false;

  void selectFrame(int id) {
    assert(id >= 0 && id <= keyframes.length);
    _selectedKeyframeId = id;
    notifyListeners();
  }

  void addEmptyFrame() {
    keyframes.insert(_selectedKeyframeId + 1, FrameModel());
    _selectedKeyframeId++;
    notifyListeners();
  }

  void addCopyFrame() {
    keyframes.insert(
      _selectedKeyframeId + 1,
      FrameModel(initialSnapshot: selectedKeyframe.snapshot),
    );
    _selectedKeyframeId++;
    notifyListeners();
  }

  void deleteSelectedFrame() {
    if (keyframes.length == 1) return;

    keyframes.removeAt(_selectedKeyframeId);
    if (_selectedKeyframeId != 0) _selectedKeyframeId--;

    notifyListeners();
  }
}
