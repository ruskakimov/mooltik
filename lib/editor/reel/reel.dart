import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/reel/reel_model.dart';

const thumbnailSize = Size(112, 64);

class Reel extends StatefulWidget {
  const Reel({Key key}) : super(key: key);

  @override
  _ReelState createState() => _ReelState();
}

class _ReelState extends State<Reel> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    // _selectedId = context.read<reelModel>().selectedFrameId;
    final reel = context.read<ReelModel>();
    controller = ScrollController()
      ..addListener(() {
        int i = (controller.offset / thumbnailSize.height).round();
        reel.selectFrame(i);
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

    final reel = context.watch<ReelModel>();

    var visibleFrame = reel.frames.first;
    final visibleFrames = reel.frames.map((f) {
      if (f != null) {
        visibleFrame = f;
      }
      return visibleFrame;
    }).toList();

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(builder: (context, constraints) {
            final padding = (constraints.maxHeight - thumbnailSize.height) / 2;
            final lastIndex = reel.frames.length - 1;

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
                      // Swiped to left.
                      reel.deleteFrameAt(index);
                    } else {
                      // Swiped to right.
                      reel.createOrRestoreFrameAt(index);
                    }
                  },
                  child: FrameThumbnail(
                    frame: visibleFrames[index],
                    size: thumbnailSize,
                    selected: index == reel.selectedFrameId,
                    copy: reel.frames[index] == null,
                  ),
                ),
              ),
              itemCount: reel.frames.length,
              controller: controller,
            );
          }),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (reel.canRemoveFrameSlot)
                    Container(
                      color: Colors.blueGrey[800],
                      width: 18,
                      height: 18,
                    ),
                  BarIconButton(
                    icon: FontAwesomeIcons.minusSquare,
                    onTap:
                        reel.canRemoveFrameSlot ? reel.removeFrameSlot : null,
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.blueGrey[800],
                    width: 18,
                    height: 18,
                  ),
                  BarIconButton(
                    icon: FontAwesomeIcons.plusSquare,
                    onTap: reel.addFrameSlot,
                  ),
                ],
              ),
            ],
          ),
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
