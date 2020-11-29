import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';

class FrameSliver extends StatelessWidget {
  const FrameSliver({
    Key key,
    @required this.frame,
    @required this.width,
    this.height = 60,
    @required this.selected,
  }) : super(key: key);

  final FrameModel frame;
  final double width;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 0.5,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FrameThumbnail(frame: frame),
        ),
      ),
    );
  }
}
