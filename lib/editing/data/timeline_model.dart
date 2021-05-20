import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.sceneSeq,
    @required TickerProvider vsync,
  })  : assert(sceneSeq != null && sceneSeq.length > 0),
        _playheadController = AnimationController(
          vsync: vsync,
          duration: sceneSeq.totalDuration,
        ) {
    _playheadController.addListener(() {
      final newPlayhead = _fractionAsPlayhead(_playheadController.value);
      _setPlayhead(newPlayhead);

      if (playheadPosition == playheadEndBound) {
        _playheadController.stop();
      }

      notifyListeners();
    });
    sceneSeq.addListener(notifyListeners);
  }

  final Sequence<Scene> sceneSeq;
  final AnimationController _playheadController;

  Duration get playheadPosition => sceneSeq.playhead;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => sceneSeq.totalDuration;

  Scene get currentScene => sceneSeq.current;

  int get currentSceneNumber => sceneSeq.currentIndex + 1;

  Duration get currentSceneStart => sceneSeq.currentSpanStart;

  Duration get currentSceneEnd => sceneSeq.currentSpanEnd;

  Duration get currentSceneEndInclusive =>
      sceneSeq.currentSpanEnd - Duration(microseconds: 1);

  /// Inclusive playhead start bound.
  Duration get playheadStartBound =>
      isSceneBound ? currentSceneStart : Duration.zero;

  /// Inclusive playhead end bound.
  Duration get playheadEndBound =>
      isSceneBound ? currentSceneEndInclusive : totalDuration;

  CompositeImage get currentFrame =>
      currentScene.imageAt(playheadPosition - sceneSeq.currentSpanStart);

  /// Playhead is constrained to the current scene bounds.
  bool get isSceneBound => _isSceneBound;
  bool _isSceneBound = false;
  set isSceneBound(bool value) {
    _isSceneBound = value;
    notifyListeners();
  }

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    _setPlayhead(playheadPosition);
    notifyListeners();
  }

  /// Animates to a new playhead position.
  void animateTo(Duration newPlayheadPosition) {
    _preparePlayheadController();
    _playheadController.animateTo(
      _playheadAsFraction(newPlayheadPosition),
      duration: const Duration(milliseconds: 150),
    );
    notifyListeners();
  }

  /// Moves playhead by [diff].
  void scrub(Duration diff) {
    if (isPlaying) {
      _playheadController.stop();
    }
    _setPlayhead(playheadPosition + diff);
    notifyListeners();
  }

  void play() {
    _preparePlayheadController();
    _playheadController.forward();
    notifyListeners();
  }

  void _preparePlayheadController() {
    _playheadController.duration = totalDuration;
    _playheadController.value = _playheadAsFraction(playheadPosition);
  }

  void pause() {
    _playheadController.stop();
    notifyListeners();
  }

  void _setPlayhead(Duration playhead) {
    sceneSeq.playhead = (playhead).clamp(playheadStartBound, playheadEndBound);
  }

  double _playheadAsFraction(Duration playhead) =>
      playhead.inMicroseconds / totalDuration.inMicroseconds;

  Duration _fractionAsPlayhead(double fraction) =>
      Duration(microseconds: (totalDuration * fraction).inMicroseconds);
}
