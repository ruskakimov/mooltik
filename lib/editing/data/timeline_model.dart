import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

const Duration minFrameDuration = Duration(milliseconds: 42);

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
    TickerProvider vsync,
  })  : assert(frames != null && frames.isNotEmpty),
        _currentFrameIndex = 0,
        _currentFrameStart = Duration.zero,
        _playheadController = AnimationController(
          vsync: vsync,
          duration: calcTotalDuration(frames),
        ) {
    _playheadController.addListener(() {
      _updateCurrentFrame();
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

  FrameModel get currentFrame => frames[_currentFrameIndex];

  FrameModel get previousFrame =>
      _currentFrameIndex > 0 ? frames[_currentFrameIndex - 1] : null;

  FrameModel get nextFrame => _currentFrameIndex < frames.length - 1
      ? frames[_currentFrameIndex + 1]
      : null;

  int get currentFrameIndex => _currentFrameIndex;
  int _currentFrameIndex;

  bool get atLastFrame => _currentFrameIndex == frames.length - 1;

  Duration get currentFrameStartTime => _currentFrameStart;
  Duration _currentFrameStart;

  Duration get currentFrameEndTime =>
      _currentFrameStart + currentFrame.duration;

  void _updateCurrentFrame() {
    if (playheadPosition < _currentFrameStart) {
      _goToPrevFrame();
    } else if (playheadPosition >= currentFrameEndTime) {
      _goToNextFrame();
    }
  }

  void _goToPrevFrame() {
    if (_currentFrameIndex == 0) return;
    _currentFrameIndex--;
    _currentFrameStart -= currentFrame.duration;
  }

  void _goToNextFrame() {
    if (atLastFrame) return;
    _currentFrameStart = currentFrameEndTime;
    _currentFrameIndex++;
  }

  void _resetCurrentFrame() {
    _currentFrameIndex = 0;
    _currentFrameStart = Duration.zero;
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
    _resetCurrentFrame();
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

  bool get stepBackwardAvailable => !isPlaying && _currentFrameIndex > 0;

  void stepBackward() {
    if (!stepBackwardAvailable) return;
    final Duration time =
        _currentFrameStart - frames[_currentFrameIndex - 1].duration;
    _playheadController.value = _fraction(time);
    _updateCurrentFrame();
    notifyListeners();
  }

  bool get stepForwardAvailable => !isPlaying && !atLastFrame;

  void stepForward() {
    if (!stepForwardAvailable) return;
    _playheadController.value = _fraction(currentFrameEndTime);
    _updateCurrentFrame();
    notifyListeners();
  }

  void addFrameAfterCurrent() {
    final newFrame = FrameModel(size: frames.first.size);
    frames.insert(_currentFrameIndex + 1, newFrame);
    _playheadController.duration += newFrame.duration;
    stepForward();
    notifyListeners();
  }

  void deleteFrameAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return;

    _playheadController.duration -= frames[frameIndex].duration;
    frames.removeAt(frameIndex);
    _updateCurrentFrame();
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
    _updateCurrentFrame();
    notifyListeners();
  }

  void changeCurrentFrameDuration(Duration newDuration) {
    if (newDuration <= minFrameDuration) return;

    final prevPlayheadPosition = playheadPosition;

    currentFrame.duration = newDuration;
    _playheadController.duration = calcTotalDuration(frames);

    // Keep playhead inside current frame.
    _playheadController.value = _fraction(
      prevPlayheadPosition < currentFrameEndTime
          ? prevPlayheadPosition
          // Current frame will change when playhead equals `currentFrameEndTime`.
          : currentFrameEndTime - Duration(milliseconds: 1),
    );

    notifyListeners();
  }
}
