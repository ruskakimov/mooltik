import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.sceneSeq,
    @required TickerProvider vsync,
    @required this.createNewFrame,
  })  : assert(sceneSeq != null && sceneSeq.length > 0),
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

  final Sequence<SceneModel> sceneSeq;
  final AnimationController _playheadController;
  final Future<FrameModel> Function() createNewFrame;

  Duration get playheadPosition => sceneSeq.playhead;

  bool get isPlaying => _playheadController.isAnimating;

  Duration get totalDuration => sceneSeq.totalDuration;

  SceneModel get currentScene => sceneSeq.current;

  Duration get currentSceneStartTime => sceneSeq.currentSpanStart;

  Duration get currentSceneEndTime => sceneSeq.currentSpanEnd;

  FrameModel get currentFrame =>
      currentScene.frameAt(playheadPosition - currentSceneStartTime);

  /// Jumps to a new playhead position.
  void jumpTo(Duration playheadPosition) {
    sceneSeq.playhead = playheadPosition;
    notifyListeners();
  }

  /// Jumps to the start of the specified frame.
  void jumpToSceneStart(int frameIndex) {
    sceneSeq.currentIndex = frameIndex;
    notifyListeners();
  }

  /// Moves playhead by [diff].
  void scrub(Duration diff) {
    if (isPlaying) {
      _playheadController.stop();
    }
    sceneSeq.playhead += diff;
    notifyListeners();
  }

  /// Reset playhead to the beginning.
  void reset() {
    sceneSeq.playhead = Duration.zero;
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

  Future<SceneModel> createNewScene() async {
    return SceneModel(
      frames: [
        await createNewFrame(),
      ],
    );
  }

  Future<void> addNewSceneAfterCurrent() async {
    sceneSeq.insert(sceneSeq.currentIndex + 1, await createNewScene());
    notifyListeners();
  }

  void deleteSceneAt(int index) {
    sceneSeq.removeAt(index);
    notifyListeners();
  }

  Future<void> duplicateSceneAt(int index) async {
    // TODO: Duplicate frames
    sceneSeq.insert(
      index + 1,
      sceneSeq[index].copyWith(),
    );
    notifyListeners();
  }

  void changeSceneDurationAt(int index, Duration newDuration) {
    sceneSeq[index] = sceneSeq[index].copyWith(duration: newDuration);
    notifyListeners();
  }
}
