import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/add_frame_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/play_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/record_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/time_label.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/frame_menu.dart';

import 'package:provider/provider.dart';
import 'package:flutter_portal/flutter_portal.dart';

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
          PopupEntry(
            visible: timelineView.showFrameMenu,
            childAnchor: Alignment.center,
            popupAnchor: Alignment.center,
            popup: FrameMenu(),
            child: PlayButton(),
            onTapOutside: () {
              timelineView.closeFrameMenu();
            },
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
