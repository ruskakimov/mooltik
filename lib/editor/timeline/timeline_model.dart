import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required initialFrames,
  })  : assert(initialFrames.isNotEmpty),
        frames = initialFrames;

  List<FrameModel> frames;

  int get selectedFrameId => _selectedFrameId;
  int _selectedFrameId = 0;

  FrameModel get selectedFrame => frames[_selectedFrameId];

  bool get playing => _playing;
  bool _playing = false;
  int _selectedFrameIdBeforePlaying;

  void play() {
    _selectedFrameIdBeforePlaying = _selectedFrameId;
    _playing = true;
    _animate();
    notifyListeners();
  }

  Duration _calcDuration(int frames, int fps) =>
      Duration(milliseconds: (1000 * frames / fps).round());

  void _animate() async {
    if (!_playing) return;
    await Future.delayed(_calcDuration(selectedFrame.duration, 24));
    if (!_playing) return;

    _selectedFrameId = (_selectedFrameId + 1) % frames.length;
    notifyListeners();

    _animate();
  }

  void stop() {
    _playing = false;
    _selectedFrameId = _selectedFrameIdBeforePlaying;
    notifyListeners();
  }

  void selectFrame(int id) {
    assert(id >= 0 && id <= frames.length);
    _selectedFrameId = id;
    notifyListeners();
  }

  void addEmptyFrame() {
    frames.insert(_selectedFrameId + 1, FrameModel());
    _selectedFrameId++;
    notifyListeners();
  }

  void addCopyFrame() {
    frames.insert(
      _selectedFrameId + 1,
      FrameModel(initialSnapshot: selectedFrame.snapshot),
    );
    _selectedFrameId++;
    notifyListeners();
  }

  void deleteSelectedFrame() {
    if (frames.length == 1) return;

    frames.removeAt(_selectedFrameId);
    if (_selectedFrameId != 0) _selectedFrameId--;

    notifyListeners();
  }

  void setSelectedFrameDuration(int value) {
    if (value < 1) return;
    selectedFrame.duration = value;
    notifyListeners();
  }
}
