import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';

class EditorModel extends ChangeNotifier {
  EditorModel({
    required Sequence<Scene>? sceneSeq,
    this.writeToDisk,
  }) : _sceneSeq = sceneSeq;

  final Sequence<Scene>? _sceneSeq;
  final VoidCallback? writeToDisk;

  void changeCurrentSceneDescription(String newDescription) {
    final currentScene = _sceneSeq!.current;
    _sceneSeq!.swapSpanAt(
      _sceneSeq!.currentIndex,
      currentScene.copyWith(description: newDescription),
    );
    notifyListeners();
    writeToDisk?.call();
  }

  /// Whether the bottom part shows timeline or board view.
  bool get isTimelineView => _isTimelineView;
  bool _isTimelineView = true;

  void switchView() {
    _isTimelineView = !_isTimelineView;
    notifyListeners();
  }
}
