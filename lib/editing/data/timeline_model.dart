import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

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
      _syncCurrentFrameWithPlayhead();
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

  void _syncCurrentFrameWithPlayhead() {
    while (playheadPosition < _currentFrameStart && _currentFrameIndex > 0) {
      _currentFrameIndex--;
      _currentFrameStart -= currentFrame.duration;
    }

    while (playheadPosition >= currentFrameEndTime && !atLastFrame) {
      _currentFrameStart = currentFrameEndTime;
      _currentFrameIndex++;
    }
  }

  void _resetCurrentFrame() {
    _currentFrameIndex = 0;
    _currentFrameStart = Duration.zero;
  }

  double _fraction(Duration playheadPosition) =>
      playheadPosition.inMicroseconds / totalDuration.inMicroseconds;

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    _playheadController.value = _fraction(playheadPosition);
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
    _syncCurrentFrameWithPlayhead();
    notifyListeners();
  }

  bool get stepForwardAvailable => !isPlaying && !atLastFrame;

  void stepForward() {
    if (!stepForwardAvailable) return;
    _playheadController.value = _fraction(currentFrameEndTime);
    _syncCurrentFrameWithPlayhead();
    notifyListeners();
  }

  void addFrameAfterCurrent() {
    insertFrameAt(_currentFrameIndex, FrameModel(size: frames.first.size));
    notifyListeners();
  }

  void insertFrameAt(int frameIndex, FrameModel frame) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex > frames.length) return;

    final prevPlayheadPosition = playheadPosition;
    frames.insert(frameIndex, frame);

    // Increase total.
    _playheadController.duration += frame.duration;

    if (frameIndex < _currentFrameIndex) {
      _currentFrameIndex++;
      _currentFrameStart += frame.duration;
      jumpTo(prevPlayheadPosition + frame.duration);
    } else {
      jumpTo(prevPlayheadPosition);
    }

    _syncCurrentFrameWithPlayhead();
    notifyListeners();
  }

  void deleteFrameAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return;
    if (frames.length < 2) return;

    final prevPlayheadPosition = playheadPosition;
    final removedDuration = frames[frameIndex].duration;
    frames.removeAt(frameIndex);

    // Reduce total.
    _playheadController.duration -= removedDuration;

    if (frameIndex < _currentFrameIndex) {
      _currentFrameIndex--;
      _currentFrameStart -= removedDuration;
      jumpTo(prevPlayheadPosition - removedDuration);
    } else {
      jumpTo(prevPlayheadPosition);
    }

    _syncCurrentFrameWithPlayhead();
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
    insertFrameAt(frameIndex + 1, newFrame);
  }

  void changeFrameDurationAt(int frameIndex, Duration newDuration) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return;

    final prevPlayheadPosition = playheadPosition;

    frames[frameIndex].duration = newDuration;
    _playheadController.duration = calcTotalDuration(frames);

    // Keep playhead fixed.
    _playheadController.value = _fraction(prevPlayheadPosition);
    _syncCurrentFrameWithPlayhead();
    _currentFrameStart = frameStartTimeAt(_currentFrameIndex);

    notifyListeners();
  }

  Duration frameStartTimeAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return null;
    return calcTotalDuration(frames.sublist(0, frameIndex));
  }

  Duration frameEndTimeAt(int frameIndex) {
    // Outside index range.
    if (frameIndex < 0 || frameIndex >= frames.length) return null;
    return frameStartTimeAt(frameIndex) + frames[frameIndex].duration;
  }
}
