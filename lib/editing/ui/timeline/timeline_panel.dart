import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline/timeline_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/editor_model.dart';
import 'package:mooltik/editing/ui/timeline/board_view.dart';
import 'package:mooltik/editing/ui/timeline/timeline_view_button.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorModel>();

    final safePadding = MediaQuery.of(context).padding;

    return Material(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: TimelineActionbar(),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: editor.isTimelineView ? TimelineView() : BoardView(),
                ),
                if (!context.watch<TimelineViewModel>().isEditingScene)
                  Positioned(
                    bottom: 8 + safePadding.bottom,
                    left: 4 + safePadding.left,
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
