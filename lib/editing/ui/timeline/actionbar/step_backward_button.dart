import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';

class StepBackwardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    return AppIconButton(
      icon: FontAwesomeIcons.stepBackward,
      onTap: timeline.stepBackwardAvailable ? timeline.stepBackward : null,
    );
  }
}
