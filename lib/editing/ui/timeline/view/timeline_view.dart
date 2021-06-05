import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/play_mode_button.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_end_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_start_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/scene_end_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/visibility_button.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_painter.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return LayoutBuilder(builder: (context, constraints) {
      timelineView.size = constraints.biggest;

      return SingleChildScrollView(
        child: SizedBox(
          height: max(timelineView.viewHeight, constraints.maxHeight),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onScaleStart: timelineView.onScaleStart,
                onScaleUpdate: timelineView.onScaleUpdate,
                onScaleEnd: timelineView.onScaleEnd,
                onTapUp: timelineView.onTapUp,
                child: CustomPaint(
                  painter: TimelinePainter(timelineView),
                ),
              ),
              if (timelineView.isEditingScene) ...[
                for (var i = 0; i < timelineView.sceneLayers.length; i++) ...[
                  PlayModeButton(layerIndex: i),
                  VisibilityButton(layerIndex: i),
                ],
                SceneEndHandle(),
              ],
              if (timelineView.showResizeStartHandle)
                ResizeStartHandle(timelineView: timelineView),
              if (timelineView.showResizeEndHandle)
                ResizeEndHandle(timelineView: timelineView),
            ],
          ),
        ),
      );
    });
  }
}
