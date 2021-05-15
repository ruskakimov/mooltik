import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel(this.frameSeq) : _currentIndex = frameSeq.currentIndex;

  final Sequence<Frame> frameSeq;

  Frame get currentFrame => frameSeq[_currentIndex];

  int get currentIndex => _currentIndex;
  int _currentIndex;

  void setCurrent(int index) {
    if (index < 0 || index >= frameSeq.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  void appendFrame(Frame frame) {
    frameSeq.insert(frameSeq.length, frame);
    notifyListeners();
  }

  void addBeforeCurrent(Frame frame) {
    frameSeq.insert(_currentIndex, frame);
    _currentIndex++;
    notifyListeners();
  }

  void addAfterCurrent(Frame frame) {
    frameSeq.insert(_currentIndex + 1, frame);
    notifyListeners();
  }

  void removeCurrent() {
    frameSeq.removeAt(_currentIndex);
    _currentIndex = _currentIndex.clamp(0, frameSeq.length - 1);
    notifyListeners();
  }

  /// Used by easel to update the frame image.
  void replaceCurrentFrame(Frame newFrame) {
    frameSeq[_currentIndex] = newFrame;
    notifyListeners();
  }
}
