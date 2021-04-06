import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required Sequence<SceneModel> sceneSeq,
    @required TickerProvider vsync,
  })  : assert(sceneSeq != null && sceneSeq.length > 0),
        _sceneSeq = sceneSeq,
        _playheadController = AnimationController(
          vsync: vsync,
          duration: sceneSeq.totalDuration,
        ) {
    _playheadController.addListener(() {
      sceneSeq.playhead = Duration(
        milliseconds:
            (sceneSeq.totalDuration * _playheadController.value).inMilliseconds,
      );
      notifyListeners();
    });
  }

  final Sequence<SceneModel> _sceneSeq;
  final AnimationController _playheadController;

  Duration get playheadPosition => _sceneSeq.playhead;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => _sceneSeq.totalDuration;

  SceneModel get currentScene => _sceneSeq.current;

  Duration get currentSceneStartTime => _sceneSeq.currentSpanStart;

  Duration get currentSceneEndTime => _sceneSeq.currentSpanEnd;

  FrameModel get currentFrame =>
      currentScene.frameAt(playheadPosition - currentSceneStartTime);

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    _sceneSeq.playhead = playheadPosition;
    notifyListeners();
  }

  /// Jumps to the start of the specified scene.
  void jumpToSceneStart(int index) {
    _sceneSeq.currentIndex = index;
    notifyListeners();
  }

  /// Moves playhead by [diff].
  void scrub(Duration diff) {
    if (isPlaying) {
      _playheadController.stop();
    }
    _sceneSeq.playhead += diff;
    notifyListeners();
  }

  /// Reset playhead to the beginning.
  void reset() {
    _sceneSeq.playhead = Duration.zero;
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

  void insertSceneAt(int index, SceneModel scene) {
    _sceneSeq.insert(index, scene);
    notifyListeners();
  }

  void deleteSceneAt(int index) {
    _sceneSeq.removeAt(index);
    notifyListeners();
  }

  void changeSceneDurationAt(int index, Duration newDuration) {
    _sceneSeq[index] = _sceneSeq[index].copyWith(duration: newDuration);
    notifyListeners();
  }
}
