import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/play_mode_button.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/playhead.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_end_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_start_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/scene_end_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/speed_button.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/visibility_button.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_painter.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return LayoutBuilder(builder: (context, constraints) {
      timelineView.size = constraints.biggest;

      final safePadding = MediaQuery.of(context).padding;

      return SingleChildScrollView(
        child: SizedBox(
          height: max(
            timelineView.viewHeight + safePadding.bottom,
            constraints.maxHeight,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTapUp: timelineView.onTapUp,
                child: CustomPaint(
                  painter: TimelinePainter(timelineView),
                ),
              ),
              Playhead(),
              if (timelineView.isEditingScene) ...[
                ..._buildLayerActionButtons(timelineView.sceneLayerCount),
                SceneEndHandle(),
              ],
              if (timelineView.showResizeStartHandle)
                ResizeStartHandle(timelineView: timelineView),
              if (timelineView.showResizeEndHandle)
                ResizeEndHandle(timelineView: timelineView),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleStart: timelineView.onScaleStart,
                onScaleUpdate: timelineView.onScaleUpdate,
                onScaleEnd: timelineView.onScaleEnd,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildLayerActionButtons(int layerCount) {
    final buttons = <Widget>[];

    for (var i = 0; i < layerCount; i++) {
      var j = 0;
      buttons.addAll([
        SpeedButton(rowIndex: i, colIndex: j++),
        PlayModeButton(rowIndex: i, colIndex: j++),
        VisibilityButton(rowIndex: i, colIndex: j++),
      ]);
    }

    return buttons;
  }
}
