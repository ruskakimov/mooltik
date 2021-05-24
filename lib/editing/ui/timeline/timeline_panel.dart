import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/playhead.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key key,
  }) : super(key: key);

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
                TimelineView(),
                Playhead(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
