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

  bool get onion => _onion;
  bool _onion = false;
  set onion(bool value) {
    _onion = value;
    notifyListeners();
  }

  FrameModel get visibleFrameBefore {
    if (playing || !onion) return null;
    int i = _selectedFrameId - 1;
    while (i >= 0 && frames[i] == null) i--;
    return i >= 0 ? frames[i] : null;
  }

  FrameModel get visibleFrameAfter {
    if (playing || !onion) return null;
    int i = _selectedFrameId + 1;
    while (i < frames.length && frames[i] == null) i++;
    return i < frames.length ? frames[i] : null;
  }

  int get _visibleFrameId {
    int i = _selectedFrameId;
    while (frames[i] == null) i--;
    return i;
  }

  FrameModel get visibleFrame => frames[_visibleFrameId];

  List<int> get frameDurations {
    final durations = <int>[];
    int c = 1;

    for (final frame in frames.reversed) {
      if (frame == null) {
        durations.add(0);
        c++;
      } else {
        durations.add(c);
        c = 1;
      }
    }
    return durations.reversed.toList();
  }

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
    await Future.delayed(const Duration(microseconds: 41666));
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

  void addFrameSlot() {
    frames.insert(_selectedFrameId + 1, null);
    notifyListeners();
  }

  bool get canRemoveFrameSlot =>
      _selectedFrameId != frames.length - 1 &&
      frames[_selectedFrameId + 1] == null;

  void removeFrameSlot() {
    if (!canRemoveFrameSlot) return;

    frames.removeAt(_selectedFrameId + 1);
    notifyListeners();
  }

  bool get canDeleteSelectedFrame =>
      frames.length > 1 &&
      !(_selectedFrameId == 0 && frames[_selectedFrameId + 1] == null);

  void deleteSelectedFrame() {
    if (!canDeleteSelectedFrame) return;

    frames.removeAt(_selectedFrameId);
    if (_selectedFrameId != 0) _selectedFrameId--;

    notifyListeners();
  }

  FrameModel createFrameInSelectedSlot() {
    if (selectedFrame != null) return null;

    frames[_selectedFrameId] = FrameModel(
      initialSnapshot: visibleFrame.snapshot,
    );

    notifyListeners();
    return frames[_selectedFrameId];
  }
}
