import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';

class ResizeStartHandle extends StatelessWidget {
  const ResizeStartHandle({
    Key key,
    @required this.timelineView,
  }) : super(key: key);

  final TimelineViewModel timelineView;

  @override
  Widget build(BuildContext context) {
    return TimelinePositioned(
      timestamp: timelineView.selectedSliverStartTime,
      y: timelineView.selectedSliverMidY,
      width: resizeHandleWidth,
      height: resizeHandleHeight,
      onDragUpdate: (Duration updatedTime) =>
          timelineView.onStartTimeHandleDragUpdate(updatedTime),
      child: ResizeHandle(),
    );
  }
}
