import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';

class BoardView extends StatelessWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    final scenes = timeline.sceneSeq.iterable;

    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      onReorder: (i, j) {},
      children: [
        for (final scene in scenes)
          Board(
            key: Key(scene.allFrames.first.file.path),
            scene: scene,
          ),
      ],
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.scene,
  }) : super(key: key);

  final Scene scene;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      color: Colors.red,
    );
  }
}
