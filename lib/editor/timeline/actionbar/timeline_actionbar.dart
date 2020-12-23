import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            portal: FrameMenu(),
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

class FrameMenu extends StatelessWidget {
  const FrameMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 10,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16),
          LabeledIconButton(
            icon: FontAwesomeIcons.copy,
            label: 'Duplicate',
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          SizedBox(width: 16),
          LabeledIconButton(
            icon: FontAwesomeIcons.trashAlt,
            label: 'Delete',
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class LabeledIconButton extends StatelessWidget {
  const LabeledIconButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
