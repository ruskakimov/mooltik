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

  int get _visibleFrameId {
    int i = _selectedFrameId;
    while (frames[i] == null) i--;
    return i;
  }

  FrameModel get visibleFrame => frames[_visibleFrameId];

  bool get playing => _playing;
  bool _playing = false;
  int _selectedFrameIdBeforePlaying;

  void play() {
    _selectedFrameIdBeforePlaying = _selectedFrameId;
    _playing = true;
    _animate();
    notifyListeners();
  }

  void _animate() async {
    if (!_playing) return;
    await Future.delayed(_calcDuration(selectedFrame.duration, 24));
    if (!_playing) return;

    _selectedFrameId =
        (_selectedFrameId + selectedFrame.duration) % frames.length;
    notifyListeners();

    _animate();
  }

  Duration _calcDuration(int frames, int fps) =>
      Duration(milliseconds: (1000 * frames / fps).round());

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

  void addFrameSlot() {
    frames.insert(_selectedFrameId + 1, null);
    visibleFrame.duration += 1;
    notifyListeners();
  }

  bool get canRemoveFrameSlot =>
      _selectedFrameId != frames.length - 1 &&
      frames[_selectedFrameId + 1] == null;

  void removeFrameSlot() {
    if (!canRemoveFrameSlot) return;

    frames.removeAt(_selectedFrameId + 1);
    visibleFrame.duration -= 1;
    notifyListeners();
  }

  bool get canDeleteSelectedFrame => frames.length > 1;

  void deleteSelectedFrame() {
    if (!canDeleteSelectedFrame) return;

    frames.removeAt(_selectedFrameId);
    if (_selectedFrameId != 0) _selectedFrameId--;

    notifyListeners();
  }

  FrameModel createFrameInSelectedSlot() {
    if (selectedFrame != null) return null;

    visibleFrame.duration = _selectedFrameId - _visibleFrameId;

    frames[_selectedFrameId] = FrameModel(
      initialSnapshot: visibleFrame.snapshot,
    );

    notifyListeners();
    return frames[_selectedFrameId];
  }
}
