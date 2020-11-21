import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

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
    return ColoredBox(
      color:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: _Thumbnail(frame: frame),
          ),
          SizedBox(
            width: 48,
            child: selected
                ? _DurationSlider(value: frame.duration)
                : _buildDurationLabel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationLabel(BuildContext context) {
    return Center(
      child: Text(
        '${frame.duration}',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _DurationSlider extends StatelessWidget {
  const _DurationSlider({
    Key key,
    @required this.value,
  }) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        print(details);
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    Key key,
    @required this.frame,
  }) : super(key: key);

  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: CustomPaint(
            size: Size(
              constraints.maxHeight / frame.height * frame.width,
              constraints.maxHeight,
            ),
            painter: FramePainter(frame: frame),
          ),
        );
      },
    );
  }
}
