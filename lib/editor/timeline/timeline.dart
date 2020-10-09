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
    _selectedId = context.read<TimelineModel>().selectedFrameId;
    controller = FixedExtentScrollController(initialItem: _selectedId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final timeline = context.read<TimelineModel>();
    if (!timeline.playing && timeline.selectedFrameId != _selectedId) {
      _selectedId = timeline.selectedFrameId;
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
    final _thumbnailWidth = 104.0;
    final thumbnailSize = Size(
      _thumbnailWidth,
      _thumbnailWidth /
          timeline.frames.first.width *
          timeline.frames.first.height,
    );
    final frameDurations = timeline.frameDurations;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarIconButton(
              icon: FontAwesomeIcons.trashAlt,
              onTap: timeline.canDeleteSelectedFrame
                  ? timeline.deleteSelectedFrame
                  : null,
            ),
          ],
        ),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: index == _selectedId ? 1 : 0.5,
                child: FrameThumbnail(
                  frame: timeline.frames[index],
                  size: thumbnailSize,
                  number: index + 1,
                  duration: frameDurations[index],
                ),
              ),
              childCount: timeline.frames.length,
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
              icon: FontAwesomeIcons.minusSquare,
              onTap: () {
                timeline.removeFrameSlot();
                _forceLayout();
              },
            ),
            BarIconButton(
              icon: FontAwesomeIcons.plusSquare,
              onTap: () {
                timeline.addFrameSlot();
                _forceLayout();
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
    @required this.number,
    @required this.duration,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;
  final int number;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (frame != null)
          CustomPaint(
            size: size,
            painter: FramePainter(frame: frame),
          )
        else
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
          ),
        Positioned(
          top: 2,
          left: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            color: Colors.blueGrey[800],
            child: Text('$number', style: TextStyle(fontSize: 10)),
          ),
        ),
        if (frame != null)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              color: Colors.blueGrey[800],
              child: Text('$duration', style: TextStyle(fontSize: 10)),
            ),
          ),
      ],
    );
  }
}
