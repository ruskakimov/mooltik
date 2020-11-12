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

  /*
  Onion:
  */

  bool get onion => _onion;
  bool _onion = true;
  set onion(bool value) {
    _onion = value;
    notifyListeners();
  }

  FrameModel get frameBefore {
    if (playing || !onion || _selectedFrameId == 0) return null;
    return frames[_selectedFrameId - 1];
  }

  FrameModel get frameAfter {
    if (playing || !onion || _selectedFrameId == frames.length - 1) return null;
    return frames[_selectedFrameId + 1];
  }

  /*
  Playback:
  */

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
    await Future.delayed(
      Duration(microseconds: 41666 * selectedFrame.duration),
    );
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

  /*
  Navigation:
  */

  void selectFrame(int id) {
    assert(id >= 0 && id < frames.length);
    if (id < 0 || id >= frames.length) return;
    _selectedFrameId = id;
    notifyListeners();
  }

  /*
  Operations:
  */

  void addFrame() {
    frames.add(FrameModel(size: frameSize));
    _selectedFrameId = frames.length - 1;
    notifyListeners();
  }

  void addFrameBeforeSelected() {
    frames.insert(_selectedFrameId, FrameModel(size: frameSize));
    notifyListeners();
  }

  void addFrameAfterSelected() {
    frames.insert(_selectedFrameId + 1, FrameModel(size: frameSize));
    _selectedFrameId++;
    notifyListeners();
  }

  bool get canDeleteSelectedFrame => frames.length > 1;

  void deleteSelectedFrame() {
    if (!canDeleteSelectedFrame) return;
    frames.removeAt(_selectedFrameId);

    // Update index on removing the last frame.
    if (_selectedFrameId == frames.length) {
      _selectedFrameId = frames.length - 1;
    }
    notifyListeners();
  }

  void copySelectedFrame() {
    _copiedFrame = selectedFrame;
    notifyListeners();
  }

  void pasteInSelectedFrame() {
    if (_copiedFrame == null) return;
    frames[_selectedFrameId] = FrameModel(
      id: selectedFrame.id,
      size: frameSize,
      initialSnapshot: _copiedFrame.snapshot,
    );
    notifyListeners();
  }
}
