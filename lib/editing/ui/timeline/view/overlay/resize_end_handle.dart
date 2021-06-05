import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';
import 'package:provider/provider.dart';

class ResizeEndHandle extends StatelessWidget {
  const ResizeEndHandle({
    Key? key,
    required this.timelineView,
  }) : super(key: key);

  final TimelineViewModel timelineView;

  @override
  Widget build(BuildContext context) {
    return TimelinePositioned(
      timestamp: timelineView.selectedSliverEndTime,
      y: timelineView.selectedSliverMidY,
      width: resizeHandleWidth,
      height: resizeHandleHeight,
      onDragUpdate: (Duration updatedTime) =>
          timelineView.onEndTimeHandleDragUpdate(updatedTime),
      onDragEnd: (_) {
        // Keep playhead within boundaries.
        final timeline = context.read<TimelineModel>();
        timeline.jumpTo(timeline.playheadPosition);
      },
      child: ResizeHandle(),
    );
  }
}
