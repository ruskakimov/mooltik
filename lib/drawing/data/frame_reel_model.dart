import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel({
    required this.frameSeq,
  }) : _currentIndex = frameSeq.currentIndex;

  final Sequence<Frame> frameSeq;

  Frame get currentFrame => frameSeq[_currentIndex];

  int get currentIndex => _currentIndex;
  int _currentIndex;

  void setCurrent(int index) {
    if (index < 0 || index >= frameSeq.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> appendFrame() async {
    frameSeq.insert(
      frameSeq.length,
      await frameSeq.current.cloneEmpty(),
    );
    notifyListeners();
  }

  Future<void> addBeforeCurrent() async {
    frameSeq.insert(
      _currentIndex,
      await frameSeq.current.cloneEmpty(),
    );
    _currentIndex++;
    notifyListeners();
  }

  Future<void> addAfterCurrent() async {
    frameSeq.insert(
      _currentIndex + 1,
      await frameSeq.current.cloneEmpty(),
    );
    notifyListeners();
  }

  Future<void> duplicateCurrent() async {
    if (currentFrame.image.snapshot == null) return;

    frameSeq.insert(
      _currentIndex + 1,
      await currentFrame.duplicate(),
    );
    notifyListeners();
  }

  bool get canDeleteCurrent => frameSeq.length > 1;

  void deleteCurrent() {
    final removedFrame = frameSeq.removeAt(_currentIndex);

    Future.delayed(
      Duration(seconds: 1),
      () => removedFrame.dispose(),
    );

    _currentIndex = _currentIndex.clamp(0, frameSeq.length - 1);
    notifyListeners();
  }

  /// Used by easel to update the frame image.
  void replaceCurrentFrame(Frame newFrame) {
    frameSeq[_currentIndex] = newFrame;
    notifyListeners();
  }
}
