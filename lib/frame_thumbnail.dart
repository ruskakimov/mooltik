import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final Frame frame;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      foregroundDecoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.red, width: 3) : null,
      ),
      child: Material(
        elevation: 2,
        color: Colors.white,
        child: InkWell(
          child: CustomPaint(
            size: Size(60, 60),
            painter: FramePainter(frame),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
