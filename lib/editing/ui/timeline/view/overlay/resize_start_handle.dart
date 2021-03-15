import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_handle.dart';
import 'package:provider/provider.dart';

class ResizeStartHandle extends StatefulWidget {
  @override
  _ResizeStartHandleState createState() => _ResizeStartHandleState();
}

class _ResizeStartHandleState extends State<ResizeStartHandle> {
  Offset _dragStartOffset;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final timeline = context.watch<TimelineModel>();

    final frameSliverMid = timelineView.frameSliverTop +
        (timelineView.frameSliverBottom - timelineView.frameSliverTop) / 2;

    final offset = Offset(
      timelineView.xFromTime(
              timeline.frameStartTimeAt(timelineView.selectedFrameIndex)) -
          resizeHandleWidth / 2,
      frameSliverMid - resizeHandleHeight / 2,
    );

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          _dragStartOffset = offset;
        },
        onHorizontalDragUpdate: (details) {
          final timelinePosition = details.localPosition + _dragStartOffset;
          timelineView.onStartTimeHandleDragUpdate(timelinePosition.dx);
        },
        child: ResizeHandle(),
      ),
    );
  }
}
