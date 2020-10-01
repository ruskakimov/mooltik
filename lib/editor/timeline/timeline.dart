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

  @override
  void initState() {
    super.initState();
    _selectedId = 0;
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

  @override
  Widget build(BuildContext context) {
    // Update when selected frame is painted on.
    context.watch<FrameModel>();

    final timeline = context.watch<TimelineModel>();
    final thumbnailSize = Size(
      150,
      150 / timeline.keyframes.first.width * timeline.keyframes.first.height,
    );

    return Column(
      children: [
        Expanded(
          child: CupertinoPicker.builder(
            scrollController: controller,
            useMagnifier: false,
            diameterRatio: 2,
            squeeze: 1,
            onSelectedItemChanged: timeline.selectFrame,
            itemExtent: thumbnailSize.height,
            childCount: timeline.keyframes.length,
            itemBuilder: (context, index) => FrameThumbnail(
              frame: timeline.keyframes[index],
              size: thumbnailSize,
            ),
          ),
        ),
        Row(
          children: [
            BarIconButton(
              icon: FontAwesomeIcons.plusCircle,
              onTap: () {
                timeline.addEmptyFrame();
              },
            ),
            Spacer(),
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
