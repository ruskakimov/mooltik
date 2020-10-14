import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

const thumbnailSize = Size(112, 64);

class Timeline extends StatefulWidget {
  const Timeline({Key key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    // _selectedId = context.read<TimelineModel>().selectedFrameId;
    final timeline = context.read<TimelineModel>();
    controller = ScrollController()
      ..addListener(() {
        int i = (controller.offset / thumbnailSize.height).round();
        timeline.selectFrame(i);
      });
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

    var visibleFrame = timeline.frames.first;
    final visibleFrames = timeline.frames.map((f) {
      if (f != null) {
        visibleFrame = f;
      }
      return visibleFrame;
    }).toList();

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final padding = (constraints.maxHeight - thumbnailSize.height) / 2;
            final lastIndex = timeline.frames.length - 1;

            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? padding : 0,
                  bottom: index == lastIndex ? padding : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    controller.animateTo(
                      index * thumbnailSize.height,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                    );
                  },
                  onHorizontalDragEnd: (dragDetails) {
                    final toLeft = dragDetails.velocity.pixelsPerSecond.dx < 0;
                    if (toLeft) {
                      timeline.deleteFrameAt(index);
                    } else {
                      if (timeline.frames[index] == null) {
                        timeline.paste(index);
                      } else {
                        timeline.copy(index);
                      }
                    }
                  },
                  child: FrameThumbnail(
                    frame: visibleFrames[index],
                    size: thumbnailSize,
                    selected: index == timeline.selectedFrameId,
                    copy: timeline.frames[index] == null,
                  ),
                ),
              ),
              itemCount: timeline.frames.length,
              controller: controller,
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BarIconButton(
              icon: FontAwesomeIcons.minusSquare,
              onTap:
                  timeline.canRemoveFrameSlot ? timeline.removeFrameSlot : null,
            ),
            BarIconButton(
              icon: FontAwesomeIcons.plusSquare,
              onTap: timeline.addFrameSlot,
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
    @required this.selected,
    @required this.copy,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;
  final bool selected;
  final bool copy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: copy ? 0.5 : 1,
          child: CustomPaint(
            size: size,
            painter: FramePainter(frame: frame),
          ),
        ),
        if (selected)
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 4),
            ),
          ),
      ],
    );
  }
}
