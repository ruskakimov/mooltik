import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel({
    required this.frameSeq,
    required CreateNewFrame createNewFrame,
  })  : _currentIndex = frameSeq.currentIndex,
        _createNewFrame = createNewFrame;

  final Sequence<Frame> frameSeq;
  final CreateNewFrame _createNewFrame;

  Frame get currentFrame => frameSeq[_currentIndex];

  int get currentIndex => _currentIndex;
  int _currentIndex;

  void setCurrent(int index) {
    if (index < 0 || index >= frameSeq.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> appendFrame() async {
    frameSeq.insert(frameSeq.length, await _createNewFrame());
    notifyListeners();
  }

  Future<void> addBeforeCurrent() async {
    frameSeq.insert(_currentIndex, await _createNewFrame());
    _currentIndex++;
    notifyListeners();
  }

  Future<void> addAfterCurrent() async {
    frameSeq.insert(_currentIndex + 1, await _createNewFrame());
    notifyListeners();
  }

  Future<void> duplicateCurrent() async {
    if (currentFrame.image.snapshot == null) return;

    final duplicateDiskImage = (await _createNewFrame()).image;
    duplicateDiskImage.changeSnapshot(currentFrame.image.snapshot!.clone());
    duplicateDiskImage.saveSnapshot();

    frameSeq.insert(
      _currentIndex + 1,
      currentFrame.copyWith(image: duplicateDiskImage),
    );
    notifyListeners();
  }

  bool get canDeleteCurrent => frameSeq.length > 1;

  void deleteCurrent() {
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
