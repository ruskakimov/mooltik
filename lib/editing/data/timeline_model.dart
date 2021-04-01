import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frameSeq,
    TickerProvider vsync,
  })  : assert(frameSeq != null && frameSeq.length > 0),
        _playheadController = AnimationController(
          vsync: vsync,
          duration: frameSeq.totalDuration,
        ) {
    _playheadController.addListener(() {
      frameSeq.playhead = Duration(
        milliseconds:
            (frameSeq.totalDuration * _playheadController.value).inMilliseconds,
      );
      notifyListeners();
    });
  }

  final Sequence<FrameModel> frameSeq;
  final AnimationController _playheadController;

  Duration get playheadPosition => frameSeq.playhead;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => frameSeq.totalDuration;

  FrameModel get currentFrame => frameSeq.current;

  int get currentFrameIndex => frameSeq.currentIndex;

  Duration get currentFrameStartTime => frameSeq.currentSpanStart;

  Duration get currentFrameEndTime => frameSeq.currentSpanEnd;

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    frameSeq.playhead = playheadPosition;
    notifyListeners();
  }

  /// Jumps to the start of the specified frame.
  void jumpToFrameStart(int frameIndex) {
    frameSeq.currentIndex = frameIndex;
    notifyListeners();
  }

  /// Instantly scrolls the timeline by a [fraction] of total duration.
  void scrub(double fraction) {
    if (isPlaying) {
      _playheadController.stop();
    }
    // TODO: Switch to passing duration
    final diff = totalDuration * fraction;
    frameSeq.playhead += diff;
    notifyListeners();
  }

  /// Reset playhead to the beginning.
  void reset() {
    frameSeq.playhead = Duration.zero;
    notifyListeners();
  }

  void play() {
    _playheadController.duration = totalDuration;
    _playheadController.value =
        playheadPosition.inMicroseconds / totalDuration.inMicroseconds;
    _playheadController.forward();
    notifyListeners();
  }

  void pause() {
    _playheadController.stop();
    notifyListeners();
  }

  bool get stepBackwardAvailable =>
      !isPlaying && frameSeq.stepBackwardAvailable;

  void stepBackward() {
    frameSeq.stepBackward();
    notifyListeners();
  }

  bool get stepForwardAvailable => !isPlaying && frameSeq.stepForwardAvailable;

  void stepForward() {
    frameSeq.stepForward();
    notifyListeners();
  }

  void addFrameAfterCurrent() {
    insertFrameAt(
      frameSeq.currentIndex + 1,
      FrameModel(size: frameSeq[0].size),
    );
    notifyListeners();
  }

  void insertFrameAt(int frameIndex, FrameModel frame) {
    frameSeq.insert(frameIndex, frame);
    notifyListeners();
  }

  void deleteFrameAt(int frameIndex) {
    frameSeq.removeAt(frameIndex);
    notifyListeners();
  }

  void duplicateFrameAt(int frameIndex) {
    final newFrame = FrameModel(
      size: frameSeq[0].size,
      initialSnapshot: frameSeq[frameIndex].snapshot,
      duration: frameSeq[frameIndex].duration,
    );
    insertFrameAt(frameIndex + 1, newFrame);
  }

  void changeFrameDurationAt(int frameIndex, Duration newDuration) {
    final newFrame = FrameModel(
      id: frameSeq[frameIndex].id,
      size: frameSeq[frameIndex].size,
      initialSnapshot: frameSeq[frameIndex].snapshot,
      duration: newDuration,
    );
    frameSeq[frameIndex] = newFrame;
    notifyListeners();
  }

  Duration frameStartTimeAt(int frameIndex) => frameSeq.startTimeOf(frameIndex);

  Duration frameEndTimeAt(int frameIndex) => frameSeq.endTimeOf(frameIndex);
}
