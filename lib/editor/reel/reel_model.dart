import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class ReelModel extends ChangeNotifier {
  ReelModel({
    this.frameSize = const Size(1280, 720),
    List<FrameModel> initialFrames,
  })  : assert(frameSize != null),
        frames = initialFrames ?? [FrameModel(size: frameSize)];

  final Size frameSize;

  List<FrameModel> frames;

  int get selectedFrameId => _selectedFrameId;
  int _selectedFrameId = 0;

  FrameModel get selectedFrame => frames[_selectedFrameId];

  FrameModel _copiedFrame;
  FrameModel _lastDeleted;
  int _lastDeletedId;

  bool get onion => _onion;
  bool _onion = true;
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
    assert(id >= 0 && id < frames.length);
    if (id < 0 || id >= frames.length) return;
    _selectedFrameId = id;
    notifyListeners();
  }

  void addFrameSlot() {
    frames.insert(_selectedFrameId + 1, null);
    notifyListeners();
  }

  void addFrame() {
    frames.insert(_selectedFrameId + 1, FrameModel(size: frameSize));
    _selectedFrameId = frames.length - 1;
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

  bool canDeleteFrameAt(int id) =>
      id != 0 && frames.length > 1 && frames[id] != null;

  void deleteFrameAt(int id) {
    assert(id >= 0 && id <= frames.length);
    if (!canDeleteFrameAt(id)) return;

    _lastDeleted = frames[id];
    _lastDeletedId = id;
    frames[id] = null;
    notifyListeners();
  }

  void createOrRestoreFrameAt(int id) {
    assert(id >= 0 && id <= frames.length);
    if (frames[id] != null) return;

    if (_lastDeletedId == id && _lastDeleted != null) {
      frames[id] = _lastDeleted;
    } else {
      frames[id] = FrameModel(size: frameSize);
    }
    notifyListeners();
  }

  void copy(int id) {
    assert(id >= 0 && id <= frames.length);
    _copiedFrame = frames[id];
    notifyListeners();
  }

  void paste(int id) {
    assert(id >= 0 && id <= frames.length);
    if (_copiedFrame == null) return;
    frames[id] = FrameModel(
      size: frameSize,
      initialSnapshot: _copiedFrame.snapshot,
    );
    notifyListeners();
  }
}
