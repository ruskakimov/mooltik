import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class ReelModel extends ChangeNotifier {
  ReelModel({
    this.frameSize = const Size(1280, 720),
    List<FrameModel> initialFrames,
  })  : assert(frameSize != null),
        frames = initialFrames ?? [FrameModel(size: frameSize)] {
    _selectedFrameId = 0;
  }

  final Size frameSize;

  List<FrameModel> frames;

  FrameModel _copiedFrame;

  /*
  Navigation:
  */

  int get selectedFrameId => _selectedFrameId;
  int _selectedFrameId;

  FrameModel get selectedFrame => frames[_selectedFrameId];

  void selectFrame(int id) {
    assert(id >= 0 && id < frames.length);
    if (id == _selectedFrameId || id < 0 || id >= frames.length) return;
    _selectedFrameId = id;
    notifyListeners();
  }

  /*
  Operations:
  */

  void addFrame() {
    frames.add(FrameModel(
      size: frameSize,
      duration: frames.last.duration,
    ));
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

  /*
  Onion:
  */

  bool get onion => _onion;
  bool _onion = true;

  void toggleOnion() {
    _onion = !_onion;
    notifyListeners();
  }

  FrameModel get frameBefore {
    if (!onion || _selectedFrameId == 0) return null;
    return frames[_selectedFrameId - 1];
  }

  FrameModel get frameAfter {
    if (!onion || _selectedFrameId == frames.length - 1) return null;
    return frames[_selectedFrameId + 1];
  }
}
