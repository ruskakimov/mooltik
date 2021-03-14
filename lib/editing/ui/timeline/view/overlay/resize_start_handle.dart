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
  final double width = 24;
  final double height = 48;

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
          width / 2,
      frameSliverMid - height / 2,
    );

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          _dragStartOffset = offset;
        },
        onHorizontalDragUpdate: (details) {
          // final timelinePosition = details.localPosition + _dragStartOffset;
          // timelineView.onDurationHandleDragUpdate(timelinePosition.dx);
        },
        child: ResizeHandle(
          width: width,
          height: height,
        ),
      ),
    );
  }
}
