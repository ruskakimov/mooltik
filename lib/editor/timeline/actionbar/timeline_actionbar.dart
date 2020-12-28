import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/actionbar/add_frame_button.dart';
import 'package:mooltik/editor/timeline/actionbar/play_button.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';

import 'package:provider/provider.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/editor/timeline/actionbar/frame_menu.dart';
import 'package:mooltik/editor/timeline/actionbar/record_button.dart';
import 'package:mooltik/editor/timeline/actionbar/time_label.dart';

class TimelineActionbar extends StatelessWidget {
  const TimelineActionbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TimeLabel(),
          ),
          PortalEntry(
            visible: timelineView.showFrameMenu,
            portal: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerUp: (_) {
                timelineView.closeFrameMenu();
              },
            ),
            child: PortalEntry(
              visible: timelineView.showFrameMenu,
              childAnchor: Alignment.center,
              portalAnchor: Alignment.center,
              portal: FrameMenu(),
              child: PlayButton(),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RecordButton(),
                AddFrameButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
