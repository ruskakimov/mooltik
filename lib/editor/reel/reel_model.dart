import 'package:flutter/material.dart';

import '../frame/frame_model.dart';

class ReelModel extends ChangeNotifier {
  ReelModel({
    this.frameSize = const Size(1280, 720),
    List<FrameModel> initialFrames,
  })  : assert(frameSize != null),
        frames = initialFrames ?? [FrameModel(size: frameSize)] {
    _selectedFrameId = 0;
    _selectedFrameStart = Duration.zero;
    _selectedFrameEnd = frames.first.duration;
    _totalDuration = frames.fold(
      Duration.zero,
      (total, frame) => total + frame.duration,
    );
  }

  final Size frameSize;

  List<FrameModel> frames;

  FrameModel _copiedFrame;

  /*
  Navigation:
  */

  int get selectedFrameId => _selectedFrameId;
  int _selectedFrameId;
  Duration _selectedFrameStart;
  Duration _selectedFrameEnd;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;

  FrameModel get selectedFrame => frames[_selectedFrameId];

  void _selectNextFrame() {
    if (_selectedFrameId == frames.length - 1) return;
    _selectedFrameId++;
    _selectedFrameStart = _selectedFrameEnd;
    _selectedFrameEnd += selectedFrame.duration;
  }

  void _selectPrevFrame() {
    if (_selectedFrameId == 0) return;
    _selectedFrameId--;
    _selectedFrameEnd = _selectedFrameStart;
    _selectedFrameStart -= selectedFrame.duration;
  }

  Duration get playheadPosition => _playheadPosition;
  Duration _playheadPosition = Duration.zero;
  set playheadPosition(Duration position) {
    _playheadPosition = Duration(
      milliseconds: position.inMilliseconds.clamp(
        0,
        _totalDuration.inMilliseconds,
      ),
    );
    if (_playheadPosition < _selectedFrameStart) {
      _selectPrevFrame();
    } else if (_selectedFrameEnd < _playheadPosition) {
      _selectNextFrame();
    }
    notifyListeners();
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
    await Future.delayed(selectedFrame.duration);
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
  Operations:
  */

  void addFrame() {
    final newFrameDuration = frames.last.duration;
    frames.add(FrameModel(
      size: frameSize,
      duration: newFrameDuration,
    ));
    _totalDuration += newFrameDuration;
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
}
