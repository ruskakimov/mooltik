import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.size,
    @required this.frame,
    @required this.selected,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPaint(
          size: size,
          painter: FramePainter(frame: frame),
        ),
        Expanded(
          child: Container(
            height: size.height,
            color: selected ? Colors.amber : Colors.transparent,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  '${frame.duration}',
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.grey[850] : Colors.white,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
