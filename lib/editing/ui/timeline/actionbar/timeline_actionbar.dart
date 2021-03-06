import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/add_frame_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/play_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/time_label.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/frame_menu.dart';

import 'package:provider/provider.dart';

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
                AppIconButton(
                  icon: FontAwesomeIcons.music,
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [
                        'mp3',
                        'aac',
                        'flac',
                        'm4a',
                        'wav',
                      ],
                    );

                    // Cancelled by user.
                    if (result == null) return;
                  },
                ),
                AddFrameButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
