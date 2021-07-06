import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/ui/app_checkbox.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

class FramesPicker extends StatefulWidget {
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
  _FramesPickerState createState() => _FramesPickerState();
}

class _FramesPickerState extends State<FramesPicker> {
  late final int totalFrameCount;
  final Set<CompositeFrame> selectedFrames = Set();

  @override
  void initState() {
    super.initState();
    selectedFrames.addAll(widget.initialSelectedFrames);
    totalFrameCount = widget.framesSceneByScene.expand((list) => list).length;
  }

  bool isSelected(CompositeFrame frame) => selectedFrames.contains(frame);

  void select(CompositeFrame frame) {
    setState(() {
      selectedFrames.add(frame);
    });
  }

  void deselect(CompositeFrame frame) {
    setState(() {
      selectedFrames.remove(frame);
    });
  }

  bool get allFramesSelected => selectedFrames.length == totalFrameCount;

  void handleAllFramesTap() {
    if (allFramesSelected) {
      setState(() => selectedFrames.clear());
    } else {
      setState(() => selectedFrames.addAll(widget.initialSelectedFrames));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected frames'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'Done',
            onPressed: selectedFrames.isEmpty
                ? null
                : () {
                    widget.onSubmit(selectedFrames);
                    Navigator.of(context).pop();
                  },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: widget.framesSceneByScene.length + 1,
        itemBuilder: (context, i) {
          if (i == 0)
            return LabeledCheckbox(
              label: 'All frames',
              selected: allFramesSelected,
              onTap: handleAllFramesTap,
            );
          return SceneFramesPicker(
            sceneNumber: i,
            sceneFrames: widget.framesSceneByScene[i - 1],
            isSelected: isSelected,
            select: select,
            deselect: deselect,
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
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          SizedBox(width: 8),
          AppCheckbox(value: selected),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class SceneFramesPicker extends StatelessWidget {
  const SceneFramesPicker({
    Key? key,
    required this.sceneNumber,
    required this.sceneFrames,
    required this.isSelected,
    required this.select,
    required this.deselect,
  }) : super(key: key);

  final List<CompositeFrame> sceneFrames;

  final int sceneNumber;

  final bool Function(CompositeFrame) isSelected;
  final void Function(CompositeFrame) select;
  final void Function(CompositeFrame) deselect;

  static const _listPadding = EdgeInsets.only(
    top: 8,
    left: 16,
    right: 16,
    bottom: 16,
  );

  static const _thumbnailSize = Size(160, 90);

  bool get allSceneFramesSelected =>
      sceneFrames.every((frame) => isSelected(frame));

  void handleSceneLabelTap() {
    if (allSceneFramesSelected) {
      sceneFrames.forEach((frame) => deselect(frame));
    } else {
      sceneFrames.forEach((frame) => select(frame));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledCheckbox(
          label: 'Scene $sceneNumber',
          selected: allSceneFramesSelected,
          onTap: handleSceneLabelTap,
        ),
        SizedBox(
          height: _thumbnailSize.height + _listPadding.vertical,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: _listPadding,
            itemCount: sceneFrames.length,
            itemBuilder: (context, i) {
              final frame = sceneFrames[i];
              final selected = isSelected(frame);

              return _SceneFrameThumbnail(
                width: _thumbnailSize.width,
                thumbnail: frame.compositeImage,
                selected: selected,
                onTap: selected ? () => deselect(frame) : () => select(frame),
              );
            },
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
    required this.onTap,
  }) : super(key: key);

  final double width;
  final CompositeImage thumbnail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Opacity(
            opacity: selected ? 1 : 0.5,
            child: Container(
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
          ),
          if (selected) AppCheckbox(value: true),
        ],
      ),
    );
  }
}
