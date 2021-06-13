import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/editor_model.dart';
import 'package:mooltik/editing/ui/timeline/board_view.dart';
import 'package:mooltik/editing/ui/timeline/timeline_view_button.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/playhead.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorModel>();

    return Material(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          TimelineActionbar(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (editor.isTimelineView) ...[
                  TimelineView(),
                  Playhead(),
                ] else
                  BoardView(),
                Positioned(
                  bottom: 8,
                  left: 4,
                  child: TimelineViewButton(
                    showTimelineIcon: !editor.isTimelineView,
                    onTap: editor.switchView,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
