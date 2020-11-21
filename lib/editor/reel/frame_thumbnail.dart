import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

const double borderWidth = 4.0;

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
    @required this.selected,
  }) : super(key: key);

  final FrameModel frame;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ColoredBox(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: _buildImage(constraints, context),
            ),
            SizedBox(
              width: 48,
              child: _buildDuration(context),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImage(BoxConstraints constraints, BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            child: CustomPaint(
              size: Size(
                constraints.maxHeight / frame.height * frame.width,
                constraints.maxHeight,
              ),
              painter: FramePainter(frame: frame),
            ),
          ),
        ),
        if (selected)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: borderWidth,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  bottom: BorderSide(
                    width: borderWidth,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  left: BorderSide(
                    width: borderWidth,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDuration(BuildContext context) {
    return Center(
      child: Text(
        '${frame.duration}',
        style: TextStyle(
          fontSize: 14,
          color: selected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w900 : FontWeight.normal,
        ),
      ),
    );
  }
}
