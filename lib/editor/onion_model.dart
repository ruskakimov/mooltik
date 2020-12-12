import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

class OnionModel extends ChangeNotifier {
  OnionModel({
    @required List<FrameModel> frames,
    @required int selectedIndex,
  })  : assert(frames != null),
        assert(selectedIndex != null),
        assert(selectedIndex < frames.length),
        _frames = frames,
        _selectedIndex = selectedIndex,
        _enabled = false;

  List<FrameModel> _frames;

  int _selectedIndex;

  void updateSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
  }

  bool get enabled => _enabled;
  bool _enabled;

  void toggle() {
    _enabled = !_enabled;
    notifyListeners();
  }

  FrameModel get frameBefore =>
      _enabled && _selectedIndex > 0 ? _frames[_selectedIndex - 1] : null;

  FrameModel get frameAfter => _enabled && _selectedIndex < _frames.length - 1
      ? _frames[_selectedIndex + 1]
      : null;
}
