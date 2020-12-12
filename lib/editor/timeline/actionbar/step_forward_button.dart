import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class StepForwardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    return AppIconButton(
      icon: timeline.stepForwardAvailable
          ? FontAwesomeIcons.stepForward
          : FontAwesomeIcons.plus,
      onTap: timeline.stepForwardAvailable
          ? timeline.stepForward
          : timeline.addFrame,
    );
  }
}
