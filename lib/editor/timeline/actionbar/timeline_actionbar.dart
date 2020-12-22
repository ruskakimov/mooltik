import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/editor/timeline/actionbar/playback_controls.dart';
import 'package:mooltik/editor/timeline/actionbar/record_button.dart';
import 'package:mooltik/editor/timeline/actionbar/time_label.dart';

class TimelineActionbar extends StatelessWidget {
  const TimelineActionbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TimeLabel(),
          ),
          PortalEntry(
            visible: true,
            childAnchor: Alignment.center,
            portalAnchor: Alignment.center,
            portal: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 10,
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                width: 200,
                height: 56,
              ),
            ),
            child: RecordButton(),
          ),
          Expanded(
            child: PlaybackControls(),
          ),
        ],
      ),
    );
  }
}
