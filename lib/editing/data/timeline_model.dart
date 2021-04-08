import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

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

      if (isSceneBound) {
        sceneSeq.playhead = newPlayhead.clamp(
          currentSceneStart,
          currentSceneEndInclusive,
        );

        if (sceneSeq.playhead == currentSceneEndInclusive) {
          _playheadController.stop();
        }
      } else {
        sceneSeq.playhead = newPlayhead;
      }

      notifyListeners();
    });
    sceneSeq.addListener(notifyListeners);
  }

  final Sequence<SceneModel> sceneSeq;
  final AnimationController _playheadController;

  Duration get playheadPosition => sceneSeq.playhead;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => sceneSeq.totalDuration;

  SceneModel get currentScene => sceneSeq.current;

  Duration get currentSceneStart => sceneSeq.currentSpanStart;

  Duration get currentSceneEnd => sceneSeq.currentSpanEnd;

  Duration get currentSceneEndInclusive =>
      sceneSeq.currentSpanEnd - Duration(microseconds: 1);

  FrameModel get currentFrame =>
      currentScene.frameAt(playheadPosition - sceneSeq.currentSpanStart);

  /// Playhead is constrained to the current scene bounds.
  bool get isSceneBound => _isSceneBound;
  bool _isSceneBound = false;
  set isSceneBound(bool value) {
    _isSceneBound = value;
    notifyListeners();
  }

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    sceneSeq.playhead = playheadPosition;
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
    if (isSceneBound) {
      sceneSeq.playhead = (sceneSeq.playhead + diff).clamp(
        currentSceneStart,
        currentSceneEndInclusive,
      );
    } else {
      sceneSeq.playhead += diff;
    }
    notifyListeners();
  }

  /// Reset playhead to the beginning.
  void reset() {
    sceneSeq.playhead = Duration.zero;
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

  double _playheadAsFraction(Duration playhead) =>
      playhead.inMicroseconds / totalDuration.inMicroseconds;

  Duration _fractionAsPlayhead(double fraction) =>
      Duration(microseconds: (totalDuration * fraction).inMicroseconds);
}
