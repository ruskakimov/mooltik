import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';

class EditorModel extends ChangeNotifier {
  EditorModel({
    @required Sequence<Scene> sceneSeq,
  }) : _sceneSeq = sceneSeq;

  final Sequence<Scene> _sceneSeq;

  void changeCurrentSceneDescription(String newDescription) {
    final currentScene = _sceneSeq.current;
    _sceneSeq.swapSpanAt(
      _sceneSeq.currentIndex,
      currentScene.copyWith(description: newDescription),
    );
    notifyListeners();
  }
}
