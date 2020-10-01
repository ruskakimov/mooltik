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
  Key _keyCupertino =
      GlobalKey(); // hack to force wheel to update, https://github.com/flutter/flutter/issues/22999
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
      print('should animate to $_selectedId');
      // controller.jumpToItem(_selectedId);
      // controller.animateToItem(
      //   _selectedId,
      //   duration: Duration(milliseconds: 100),
      //   curve: Curves.easeOut,
      // );
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
            key: _keyCupertino,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarIconButton(
              icon: FontAwesomeIcons.plusCircle,
              onTap: () {
                timeline.addEmptyFrame();
                _keyCupertino = GlobalKey(); // hack
              },
            )
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
