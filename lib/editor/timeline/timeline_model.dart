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
  int _selectedKeyframeIdBeforePlaying;

  void play() {
    _selectedKeyframeIdBeforePlaying = _selectedKeyframeId;
    _playing = true;
    _animate();
    notifyListeners();
  }

  Duration _calcDuration(int frames, int fps) =>
      Duration(milliseconds: (1000 * frames / fps).round());

  void _animate() async {
    if (!_playing) return;
    await Future.delayed(_calcDuration(selectedKeyframe.duration, 24));
    if (!_playing) return;

    _selectedKeyframeId = (_selectedKeyframeId + 1) % keyframes.length;
    notifyListeners();

    _animate();
  }

  void stop() {
    _playing = false;
    _selectedKeyframeId = _selectedKeyframeIdBeforePlaying;
    notifyListeners();
  }

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

  void setSelectedFrameDuration(int value) {
    if (value < 1) return;
    selectedKeyframe.duration = value;
    notifyListeners();
  }
}
