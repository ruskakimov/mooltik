import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/editing/ui/preview/frame_thumbnail.dart';

class FrameButton extends StatelessWidget {
  const FrameButton({
    Key key,
    @required this.frame,
    this.onTap,
  }) : super(key: key);

  final FrameModel frame;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xC4C4C4).withOpacity(0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FrameThumbnail(frame: frame),
          ),
        ),
      ),
    );
  }
}
