import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/ui/app_checkbox.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

class FramesPicker extends StatelessWidget {
  const FramesPicker({
    Key? key,
    required this.framesSceneByScene,
    required this.initialSelectedFrames,
    required this.onSubmit,
  }) : super(key: key);

  final List<List<CompositeFrame>> framesSceneByScene;
  final Set<CompositeFrame> initialSelectedFrames;
  final ValueChanged<Set<CompositeFrame>> onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected frames'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'Done',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: framesSceneByScene.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return LabeledCheckbox(label: 'All frames');
          return SceneFramesPicker(
            sceneNumber: i,
            sceneFrames: framesSceneByScene[i - 1],
          );
        },
        separatorBuilder: (context, i) => Divider(
          height: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8),
        AppCheckbox(value: true),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class SceneFramesPicker extends StatelessWidget {
  const SceneFramesPicker({
    Key? key,
    required this.sceneNumber,
    required this.sceneFrames,
  }) : super(key: key);

  final List<CompositeFrame> sceneFrames;

  final int sceneNumber;

  static const _listPadding = EdgeInsets.only(
    top: 8,
    left: 16,
    right: 16,
    bottom: 16,
  );

  static const _thumbnailSize = Size(160, 90);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledCheckbox(label: 'Scene $sceneNumber'),
        SizedBox(
          height: _thumbnailSize.height + _listPadding.vertical,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: _listPadding,
            itemCount: sceneFrames.length,
            itemBuilder: (context, i) => _SceneFrameThumbnail(
              width: _thumbnailSize.width,
              thumbnail: sceneFrames[i].compositeImage,
              selected: true,
            ),
            separatorBuilder: (context, i) => SizedBox(width: 16),
          ),
        ),
      ],
    );
  }
}

class _SceneFrameThumbnail extends StatelessWidget {
  const _SceneFrameThumbnail({
    Key? key,
    required this.width,
    required this.thumbnail,
    required this.selected,
  }) : super(key: key);

  final double width;
  final CompositeImage thumbnail;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: CustomPaint(
              size: thumbnail.size,
              painter: CompositeImagePainter(thumbnail),
              isComplex: true,
            ),
          ),
        ),
        if (selected) AppCheckbox(value: true),
      ],
    );
  }
}
