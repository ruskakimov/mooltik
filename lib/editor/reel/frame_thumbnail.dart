import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.size,
    @required this.frame,
    @required this.selected,
    @required this.copy,
    this.duration,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;
  final bool selected;
  final bool copy;
  final int duration;

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
              color: duration != null
                  ? Colors.amber.withOpacity(0.8)
                  : Colors.transparent,
            ),
            child: duration != null
                ? Center(
                    child: Text(
                      '$duration',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                : null,
          ),
      ],
    );
  }
}
