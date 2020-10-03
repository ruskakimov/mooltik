import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  FixedExtentScrollController controller;
  int _selectedId;
  double _squeeze = 1;

  @override
  void initState() {
    super.initState();
    _selectedId = context.read<TimelineModel>().selectedKeyframeId;
    controller = FixedExtentScrollController(initialItem: _selectedId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final timeline = context.read<TimelineModel>();
    if (timeline.selectedKeyframeId != _selectedId) {
      _selectedId = timeline.selectedKeyframeId;
      controller.animateToItem(
        _selectedId,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _forceLayout() {
    setState(() {
      if (_squeeze == 1) {
        _squeeze = 1.000000000000001;
      } else {
        _squeeze = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update when selected frame is painted on.
    context.watch<FrameModel>();

    final timeline = context.watch<TimelineModel>();
    final _thumbnailHeight = 150.0;
    final thumbnailSize = Size(
      _thumbnailHeight,
      _thumbnailHeight /
          timeline.keyframes.first.width *
          timeline.keyframes.first.height,
    );

    return Column(
      children: [
        Expanded(
          child: ListWheelScrollView.useDelegate(
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: index == _selectedId ? 1 : 0.5,
                child: FrameThumbnail(
                  frame: timeline.keyframes[index],
                  size: thumbnailSize,
                ),
              ),
              childCount: timeline.keyframes.length,
            ),
            controller: controller,
            useMagnifier: false,
            diameterRatio: 2,
            squeeze: _squeeze,
            onSelectedItemChanged: (int index) {
              timeline.selectFrame(index);
              _selectedId = index;
            },
            itemExtent: thumbnailSize.height,
            physics: BouncingScrollPhysics(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BarIconButton(
              icon: FontAwesomeIcons.plusCircle,
              onTap: () {
                timeline.addEmptyFrame();
                _forceLayout();
              },
            ),
            BarIconButton(
              icon: FontAwesomeIcons.copy,
              onTap: () {
                timeline.addCopyFrame();
                _forceLayout();
              },
            ),
            BarIconButton(
              icon: FontAwesomeIcons.trashAlt,
              onTap: () {
                timeline.deleteSelectedFrame();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.size,
    @required this.frame,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: FramePainter(frame),
    );
  }
}
