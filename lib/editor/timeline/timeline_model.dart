import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
  })  : assert(frames != null && frames.isNotEmpty),
        _playheadPosition = Duration.zero,
        _selectedFrameIndex = 0,
        _selectedFrameStart = Duration.zero,
        _selectedFrameEnd = frames.first.duration {
    _totalDuration = frames.fold(
      Duration.zero,
      (duration, frame) => duration + frame.duration,
    );
  }

  final List<FrameModel> frames;

  Duration get playheadPosition => _playheadPosition;
  Duration _playheadPosition;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;

  FrameModel get selectedFrame => frames[_selectedFrameIndex];

  int get selectedFrameIndex => _selectedFrameIndex;
  int _selectedFrameIndex;

  double get selectedFrameProgress =>
      (_playheadPosition - _selectedFrameStart).inMilliseconds /
      selectedFrame.duration.inMilliseconds;

  Duration _selectedFrameStart;
  Duration _selectedFrameEnd;

  void _updateSelectedFrame() {
    if (_playheadPosition < _selectedFrameStart) {
      _selectPrevFrame();
    } else if (_playheadPosition > _selectedFrameEnd) {
      _selectNextFrame();
    }
  }

  void _selectPrevFrame() {
    if (_selectedFrameIndex == 0) return;
    _selectedFrameIndex--;
    _selectedFrameEnd = _selectedFrameStart;
    _selectedFrameStart -= selectedFrame.duration;
  }

  void _selectNextFrame() {
    if (_selectedFrameIndex == frames.length - 1) return;
    _selectedFrameIndex++;
    _selectedFrameStart = _selectedFrameEnd;
    _selectedFrameEnd += selectedFrame.duration;
  }

  void scrub(Duration diff) {
    _playheadPosition += diff;
    _clampPlayhead();
    _updateSelectedFrame();
    notifyListeners();
  }

  void _clampPlayhead() {
    if (_playheadPosition < Duration.zero) {
      _playheadPosition = Duration.zero;
    } else if (_playheadPosition > _totalDuration) {
      _playheadPosition = _totalDuration;
    }
  }
}
