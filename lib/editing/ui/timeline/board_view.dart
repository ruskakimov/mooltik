import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';

class BoardView extends StatelessWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    final scenes = timeline.sceneSeq.iterable.toList();

    return ReorderableListView.builder(
      scrollDirection: Axis.horizontal,
      onReorder: (i, j) {
        print('');
      },
      itemCount: scenes.length,
      itemBuilder: (context, i) {
        final scene = scenes[i];
        return Board(
          key: Key(scene.allFrames.first.file.path),
          scene: scene,
        );
      },
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
    final image = scene.imageAt(Duration.zero);

    return Container(
      width: 160,
      // color: Colors.red,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: CustomPaint(
                size: image.size,
                painter: CompositeImagePainter(image),
              ),
            ),
          ),
          Text(scene.description ?? ''),
        ],
      ),
    );
  }
}
