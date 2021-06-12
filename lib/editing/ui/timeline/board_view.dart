import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

class BoardView extends StatelessWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    final scenes = timeline.sceneSeq.iterable.toList();

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      onReorder: (i, j) {
        print('');
      },
      itemCount: scenes.length,
      itemBuilder: (context, i) {
        final scene = scenes[i];
        return GestureDetector(
          key: Key(scene.allFrames.first.file.path),
          onTap: () => timeline.jumpToSceneStart(i),
          child: Board(
            scene: scene,
            selected: scene == timeline.currentScene,
          ),
        );
      },
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.scene,
    required this.selected,
  }) : super(key: key);

  final Scene scene;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final image = scene.imageAt(Duration.zero);

    return Container(
      width: 120,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: CustomPaint(
                size: image.size,
                painter: CompositeImagePainter(image),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              scene.description ?? '',
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: selected ? Colors.grey[100] : Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
