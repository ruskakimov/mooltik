import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/board_view.dart';
import 'package:mooltik/editing/ui/timeline/timeline_mode_button.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/playhead.dart';

class TimelinePanel extends StatefulWidget {
  const TimelinePanel({
    Key? key,
  }) : super(key: key);

  @override
  _TimelinePanelState createState() => _TimelinePanelState();
}

class _TimelinePanelState extends State<TimelinePanel> {
  bool isTimelineView = true;

  @override
  Widget build(BuildContext context) {
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
                if (isTimelineView) ...[
                  TimelineView(),
                  Playhead(),
                ] else
                  BoardView(),
                Positioned(
                  bottom: 8,
                  left: 4,
                  child: TimelineModeButton(
                    showTimelineIcon: !isTimelineView,
                    onTap: _switchView,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _switchView() {
    setState(() {
      isTimelineView = !isTimelineView;
    });
  }
}
