import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
    TickerProvider vsync,
  })  : assert(frames != null && frames.isNotEmpty),
        _selectedFrameIndex = 0,
        _selectedFrameStart = Duration.zero,
        _selectedFrameEnd = frames.first.duration,
        _playheadController = AnimationController(
          vsync: vsync,
          duration: frames.fold(
            Duration.zero,
            (duration, frame) => duration + frame.duration,
          ),
        ) {
    _playheadController.addListener(() {
      _updateSelectedFrame();
      notifyListeners();
    });
  }

  final List<FrameModel> frames;
  final AnimationController _playheadController;

  Duration get playheadPosition => totalDuration * _playheadController.value;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => _playheadController.duration;

  FrameModel get selectedFrame => frames[_selectedFrameIndex];

  int get selectedFrameIndex => _selectedFrameIndex;
  int _selectedFrameIndex;

  bool get lastFrameSelected => _selectedFrameIndex == frames.length - 1;

  Duration get selectedFrameStartTime => _selectedFrameStart;
  Duration _selectedFrameStart;
  Duration _selectedFrameEnd;

  void _updateSelectedFrame() {
    if (playheadPosition < _selectedFrameStart) {
      _selectPrevFrame();
    } else if (playheadPosition >= _selectedFrameEnd) {
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
    if (lastFrameSelected) return;
    _selectedFrameIndex++;
    _selectedFrameStart = _selectedFrameEnd;
    _selectedFrameEnd += selectedFrame.duration;
  }

  void _resetSelectedFrame() {
    _selectedFrameIndex = 0;
    _selectedFrameStart = Duration.zero;
    _selectedFrameEnd = frames.first.duration;
  }

  /// Scrubs the timeline by a [fraction] of total duration.
  void scrub(double fraction) {
    _playheadController.value += fraction;
  }

  void play() {
    _playheadController.forward();
    notifyListeners();
  }

  void pause() {
    _playheadController.stop();
    notifyListeners();
  }

  void replay() {
    _playheadController
      ..reset()
      ..forward();
    _resetSelectedFrame();
    notifyListeners();
  }

  bool get stepBackwardAvailable => !isPlaying && _selectedFrameIndex > 0;

  void stepBackward() {
    if (!stepBackwardAvailable) return;
    final Duration time =
        _selectedFrameStart - frames[_selectedFrameIndex - 1].duration;
    final double fraction = time.inMilliseconds / totalDuration.inMilliseconds;
    _playheadController.value = fraction;
    _updateSelectedFrame();
    notifyListeners();
  }

  bool get stepForwardAvailable => !isPlaying && !lastFrameSelected;

  void stepForward() {
    if (!stepForwardAvailable) return;
    final double fraction =
        _selectedFrameEnd.inMilliseconds / totalDuration.inMilliseconds;
    _playheadController.value = fraction;
    _updateSelectedFrame();
    notifyListeners();
  }

  void addFrame() {
    frames.add(FrameModel(size: frames.first.size));
    _playheadController.duration += frames.last.duration;
    stepForward();
    notifyListeners();
  }
}
