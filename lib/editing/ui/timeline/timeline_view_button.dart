import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimelineViewButton extends StatelessWidget {
  const TimelineViewButton({
    Key? key,
    required this.showTimelineIcon,
    this.onTap,
  }) : super(key: key);

  final bool showTimelineIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      elevation: 2,
      child: _buildIcon(),
      onPressed: onTap,
    );
  }

  Widget _buildIcon() => showTimelineIcon
      ? Icon(
          FontAwesomeIcons.stream,
          size: 20,
        )
      : RotatedBox(
          quarterTurns: 2,
          child: Icon(FontAwesomeIcons.windowMaximize, size: 20),
        );
}
