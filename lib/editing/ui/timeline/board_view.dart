import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
      onReorder: timeline.onSceneReorder,
      itemCount: scenes.length,
      itemBuilder: (context, i) {
        final scene = scenes[i];
        return GestureDetector(
          key: Key(scene.allFrames.first.file.path),
          onTap: () => timeline.jumpToSceneStart(i),
          child: Board(
            scene: scene,
            sceneNumber: i + 1,
            selected: scene == timeline.currentScene,
            horizontal: isPortrait,
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
    required this.sceneNumber,
    required this.selected,
    this.horizontal = false,
  }) : super(key: key);

  final Scene scene;
  final int sceneNumber;
  final bool selected;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final image = scene.imageAt(Duration.zero);

    return Container(
      width: horizontal ? null : 120,
      height: horizontal ? 80 : null,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Flex(
        direction: horizontal ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumbnail(image: image),
          const SizedBox(width: 8, height: 8),
          Expanded(
            child: _Info(
              sceneNumber: sceneNumber,
              sceneDuration: scene.duration,
              sceneDescription: scene.description,
              selected: selected,
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CompositeImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    Key? key,
    required this.sceneNumber,
    required this.sceneDuration,
    required this.sceneDescription,
    required this.selected,
  }) : super(key: key);

  final int sceneNumber;
  final Duration sceneDuration;
  final String? sceneDescription;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: selected ? Colors.grey[100] : Colors.grey[500],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Scene $sceneNumber',
              style: textStyle,
            ),
            Text(
              _getDurationLabel(),
              style: textStyle,
            ),
          ],
        ),
        SizedBox(height: 4),
        Expanded(
          child: Text(
            sceneDescription ?? '',
            overflow: TextOverflow.fade,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  String _getDurationLabel() {
    final seconds = sceneDuration.inMilliseconds / 1000;
    return ' (' + seconds.toStringAsFixed(1).replaceFirst('.0', '') + 's)';
  }
}
