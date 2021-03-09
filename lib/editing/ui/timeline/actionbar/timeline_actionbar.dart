import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:mooltik/editing/data/importer_model.dart';
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
                    try {
                      final project = context.read<Project>();
                      await ImporterModel().importAudioTo(project);
                    } catch (e) {
                      final snack = SnackBar(
                        content: Text(
                          'Failed to load audio.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    }
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
