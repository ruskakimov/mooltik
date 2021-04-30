import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _visibleKey = 'frame_reel_visible';

class FrameReelModel extends ChangeNotifier {
  FrameReelModel({
    @required this.frameSeq,
    @required SharedPreferences sharedPreferences,
  })  : _preferences = sharedPreferences,
        _currentIndex = frameSeq.currentIndex,
        _visible = sharedPreferences.getBool(_visibleKey) ?? true;

  SharedPreferences _preferences;

  bool get visible => _visible;
  bool _visible;

  Future<void> toggleVisibility() async {
    _visible = !_visible;
    notifyListeners();

    await _preferences.setBool(_visibleKey, _visible);
  }

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

  /// Used by easel to update the frame image.
  void replaceCurrentFrame(Frame newFrame) {
    frameSeq[_currentIndex] = newFrame;
    notifyListeners();
  }
}
