import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';

class StepForwardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    return AppIconButton(
      icon: timeline.lastFrameSelected
          ? FontAwesomeIcons.plus
          : FontAwesomeIcons.stepForward,
      onTap: timeline.isPlaying
          ? null
          : timeline.lastFrameSelected
              ? timeline.addFrameAfterSelected
              : timeline.stepForward,
    );
  }
}
