import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:provider/provider.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
  }) : super(key: key);

  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: frame,
      builder: (BuildContext context, Widget child) {
        context.watch<FrameModel>();
        return FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: CustomPaint(
            size: frame.size,
            painter: FramePainter(frame: frame),
          ),
        );
      },
    );
  }
}
