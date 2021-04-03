import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frameSeq,
    @required TickerProvider vsync,
    @required this.createNewFrame,
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
  final Future<FrameModel> Function() createNewFrame;

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

  /// Moves playhead by [diff].
  void scrub(Duration diff) {
    if (isPlaying) {
      _playheadController.stop();
    }
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

  Future<void> addEmptyFrameAfterCurrent() async {
    insertFrameAt(
      frameSeq.currentIndex + 1,
      await createNewFrame(),
    );
  }

  Future<void> addEmptyFrameAtEnd() async {
    insertFrameAt(
      frameSeq.length,
      await createNewFrame(),
    );
  }

  void insertFrameAt(int frameIndex, FrameModel frame) {
    frameSeq.insert(frameIndex, frame);
    notifyListeners();
  }

  void deleteFrameAt(int frameIndex) {
    frameSeq.removeAt(frameIndex);
    notifyListeners();
  }

  Future<void> duplicateFrameAt(int frameIndex) async {
    final duplicate = await createNewFrame();
    duplicate.snapshot = frameSeq[frameIndex].snapshot;
    duplicate.duration = frameSeq[frameIndex].duration;
    insertFrameAt(frameIndex + 1, duplicate);
  }

  void changeFrameDurationAt(int frameIndex, Duration newDuration) {
    final newFrame = FrameModel(
      file: frameSeq[frameIndex].file,
      duration: newDuration,
    );
    newFrame.snapshot = frameSeq[frameIndex].snapshot;
    frameSeq[frameIndex] = newFrame;
    notifyListeners();
  }
}
