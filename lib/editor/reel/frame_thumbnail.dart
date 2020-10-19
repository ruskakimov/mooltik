import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            child:
                duration != null ? DurationIndicator(duration: duration) : null,
          ),
      ],
    );
  }
}

class DurationIndicator extends StatelessWidget {
  const DurationIndicator({
    Key key,
    @required this.duration,
  }) : super(key: key);

  final int duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              FontAwesomeIcons.angleUp,
              color: Colors.blueGrey[900],
              size: 12,
            ),
            Spacer(),
            Icon(
              FontAwesomeIcons.angleDown,
              color: Colors.blueGrey[900],
              size: 12,
            ),
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$duration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 4),
            Text(
              time(duration),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
        SizedBox(width: 4),
      ],
    );
  }

  String time(int frames) {
    return '${(frames / 24).toStringAsFixed(2)}s';
  }
}
