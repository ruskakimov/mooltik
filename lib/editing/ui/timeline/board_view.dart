import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

const double _columnWidth = 120;

class BoardView extends StatefulWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    final currentSceneNumber = context.read<TimelineModel>().currentSceneNumber;
    controller = ScrollController(
      initialScrollOffset: _columnWidth * (currentSceneNumber - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    final scenes = timeline.sceneSeq.iterable.toList();

    return LayoutBuilder(builder: (context, constraints) {
      final horizontalPadding = (constraints.maxWidth - _columnWidth) / 2;

      return ReorderableListView.builder(
        scrollController: controller,
        proxyDecorator: _proxyDecorator,
        header: SizedBox(width: horizontalPadding),
        padding: EdgeInsets.only(right: horizontalPadding),
        scrollDirection: Axis.horizontal,
        onReorder: timeline.onSceneReorder,
        itemCount: scenes.length,
        itemBuilder: (context, i) {
          final scene = scenes[i];
          final selected = scene == timeline.currentScene;

          return GestureDetector(
            key: Key(scene.allFrames.first.file.path),
            onTap: () {
              if (selected) {
                // Open menu.
                final timelineView = context.read<TimelineViewModel>();
                timelineView.selectScene(i);
              } else {
                timeline.jumpToSceneStart(i);
              }
            },
            child: Board(
              scene: scene,
              sceneNumber: i + 1,
              selected: selected,
            ),
          );
        },
      );
    });
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.05, animValue)!;
        final double elevation = lerpDouble(0, 10, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Material(
            child: child,
            elevation: elevation,
          ),
        );
      },
      child: child,
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.scene,
    required this.sceneNumber,
    required this.selected,
  }) : super(key: key);

  final Scene scene;
  final int sceneNumber;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final image = scene.imageAt(Duration.zero);

    return Container(
      width: _columnWidth,
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
