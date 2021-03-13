import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

const Duration minFrameDuration = Duration(milliseconds: 42);

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
    TickerProvider vsync,
  })  : assert(frames != null && frames.isNotEmpty),
        _selectedFrameIndex = 0,
        _selectedFrameStart = Duration.zero,
        _playheadController = AnimationController(
          vsync: vsync,
          duration: calcTotalDuration(frames),
        ) {
    _playheadController.addListener(() {
      _updateSelectedFrame();
      notifyListeners();
    });
  }

  static Duration calcTotalDuration(List<FrameModel> frames) => frames.fold(
        Duration.zero,
        (duration, frame) => duration + frame.duration,
      );

  final List<FrameModel> frames;
  final AnimationController _playheadController;

  Duration get playheadPosition => totalDuration * _playheadController.value;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => _playheadController.duration;

  FrameModel get selectedFrame => frames[_selectedFrameIndex];

  FrameModel get frameBeforeSelected =>
      _selectedFrameIndex > 0 ? frames[_selectedFrameIndex - 1] : null;

  FrameModel get frameAfterSelected => _selectedFrameIndex < frames.length - 1
      ? frames[_selectedFrameIndex + 1]
      : null;

  int get selectedFrameIndex => _selectedFrameIndex;
  int _selectedFrameIndex;

  bool get lastFrameSelected => _selectedFrameIndex == frames.length - 1;

  Duration get selectedFrameStartTime => _selectedFrameStart;
  Duration _selectedFrameStart;

  Duration get selectedFrameEndTime =>
      _selectedFrameStart + selectedFrame.duration;

  void _updateSelectedFrame() {
    if (playheadPosition < _selectedFrameStart) {
      _selectPrevFrame();
    } else if (playheadPosition >= selectedFrameEndTime) {
      _selectNextFrame();
    }
  }

  void _selectPrevFrame() {
    if (_selectedFrameIndex == 0) return;
    _selectedFrameIndex--;
    _selectedFrameStart -= selectedFrame.duration;
  }

  void _selectNextFrame() {
    if (lastFrameSelected) return;
    _selectedFrameStart = selectedFrameEndTime;
    _selectedFrameIndex++;
  }

  void _resetSelectedFrame() {
    _selectedFrameIndex = 0;
    _selectedFrameStart = Duration.zero;
  }

  double _fraction(Duration playheadPosition) =>
      playheadPosition.inMicroseconds / totalDuration.inMicroseconds;

  /// Scrolls to a new playhead position.
  void seekTo(Duration playheadPosition) {
    _playheadController.animateTo(
      _fraction(playheadPosition),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  /// Instantly scrolls the timeline by a [fraction] of total duration.
  void scrub(double fraction) {
    _playheadController.value += fraction;
  }

  /// Reset playhead to the beginning.
  void reset() {
    _playheadController.reset();
    _resetSelectedFrame();
    notifyListeners();
  }

  void play() {
    _playheadController.forward();
    notifyListeners();
  }

  void pause() {
    _playheadController.stop();
    notifyListeners();
  }

  bool get stepBackwardAvailable => !isPlaying && _selectedFrameIndex > 0;

  void stepBackward() {
    if (!stepBackwardAvailable) return;
    final Duration time =
        _selectedFrameStart - frames[_selectedFrameIndex - 1].duration;
    _playheadController.value = _fraction(time);
    _updateSelectedFrame();
    notifyListeners();
  }

  bool get stepForwardAvailable => !isPlaying && !lastFrameSelected;

  void stepForward() {
    if (!stepForwardAvailable) return;
    _playheadController.value = _fraction(selectedFrameEndTime);
    _updateSelectedFrame();
    notifyListeners();
  }

  void addFrameAfterSelected() {
    final newFrame = FrameModel(size: frames.first.size);
    frames.insert(_selectedFrameIndex + 1, newFrame);
    _playheadController.duration += newFrame.duration;
    stepForward();
    notifyListeners();
  }

  void deleteFrameAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return;

    _playheadController.duration -= frames[frameIndex].duration;
    frames.removeAt(frameIndex);
    _updateSelectedFrame();
    notifyListeners();
  }

  void duplicateFrameAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return;

    final newFrame = FrameModel(
      size: frames.first.size,
      initialSnapshot: frames[frameIndex].snapshot,
      duration: frames[frameIndex].duration,
    );
    frames.insert(frameIndex + 1, newFrame);
    _playheadController.duration += newFrame.duration;
    _updateSelectedFrame();
    notifyListeners();
  }

  void changeSelectedFrameDuration(Duration newDuration) {
    if (newDuration <= minFrameDuration) return;

    final prevPlayheadPosition = playheadPosition;

    selectedFrame.duration = newDuration;
    _playheadController.duration = calcTotalDuration(frames);

    // Keep playhead inside selected frame.
    _playheadController.value = _fraction(
      prevPlayheadPosition < selectedFrameEndTime
          ? prevPlayheadPosition
          // Selected frame will change when playhead equals `selectedFrameEndTime`.
          : selectedFrameEndTime - Duration(milliseconds: 1),
    );

    notifyListeners();
  }
}
