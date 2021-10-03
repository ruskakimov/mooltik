import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/editing/data/timeline/timeline_row_interfaces.dart';

class TimelineSceneRow implements TimelineSceneRowInterface {
  TimelineSceneRow(this._sceneSequence);

  final Sequence<Scene> _sceneSequence;

  @override
  int get clipCount => _sceneSequence.length;

  @override
  Iterable<Scene> get clips => _sceneSequence.iterable;

  @override
  Scene clipAt(int index) {
    return _sceneSequence[index];
  }

  @override
  void insertSceneAfter(int index, Scene newScene) {
    _sceneSequence.insert(index + 1, newScene);
  }

  @override
  Scene deleteAt(int index) {
    return _sceneSequence.removeAt(index);
  }

  @override
  Future<void> duplicateAt(int index) async {
    final duplicate = await clipAt(index).duplicate();
    _sceneSequence.insert(index + 1, duplicate);
  }

  @override
  void changeDurationAt(int index, Duration newDuration) {
    _sceneSequence.changeSpanDurationAt(index, newDuration);
  }

  @override
  Duration startTimeOf(int index) => _sceneSequence.startTimeOf(index);

  @override
  Duration endTimeOf(int index) => _sceneSequence.endTimeOf(index);
}
