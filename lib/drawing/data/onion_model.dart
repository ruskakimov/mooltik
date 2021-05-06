import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _enabledKey = 'onion_enabled';

class OnionModel extends ChangeNotifier {
  OnionModel({
    @required Sequence<Frame> frames,
    @required int selectedIndex,
    @required SharedPreferences sharedPreferences,
  })  : assert(frames != null),
        assert(selectedIndex != null),
        assert(selectedIndex < frames.length),
        assert(sharedPreferences != null),
        _frames = frames,
        _selectedIndex = selectedIndex,
        _preferences = sharedPreferences,
        _enabled = sharedPreferences.getBool(_enabledKey) ?? true;

  SharedPreferences _preferences;
  Sequence<Frame> _frames;

  int _selectedIndex;

  void updateFrames(Sequence<Frame> frames) {
    if (frames != _frames) {
      _frames = frames;
    }
  }

  void updateSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
  }

  bool get enabled => _enabled;
  bool _enabled;

  Future<void> toggle() async {
    _enabled = !_enabled;
    notifyListeners();

    await _preferences.setBool(_enabledKey, _enabled);
  }

  Frame get frameBefore =>
      _enabled && _selectedIndex > 0 ? _frames[_selectedIndex - 1] : null;

  Frame get frameAfter => _enabled && _selectedIndex < _frames.length - 1
      ? _frames[_selectedIndex + 1]
      : null;
}
