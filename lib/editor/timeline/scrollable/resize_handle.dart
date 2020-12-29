import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class PositionedResizeHandle extends StatelessWidget {
  final double width = 24;
  final double height = 48;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final timeline = context.watch<TimelineModel>();

    final frameSliverMid = timelineView.frameSliverTop +
        (timelineView.frameSliverBottom - timelineView.frameSliverTop) / 2;

    final offset = Offset(
      timelineView.xFromTime(timeline.selectedFrameEndTime) - width / 2,
      frameSliverMid - height / 2,
    );

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          final timelinePosition = details.localPosition + offset;
          timelineView.onDurationHandleDragUpdate(timelinePosition.dx);
        },
        child: ResizeHandle(
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class ResizeHandle extends StatelessWidget {
  const ResizeHandle({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.primary,
      elevation: 10,
      child: SizedBox(
        width: width,
        height: height,
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.drag_handle_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
