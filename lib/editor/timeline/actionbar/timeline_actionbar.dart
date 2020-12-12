import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/actionbar/step_backward_button.dart';
import 'package:mooltik/editor/timeline/actionbar/step_forward_button.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/timeline/actionbar/time_label.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class TimelineActionbar extends StatelessWidget {
  const TimelineActionbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimeLabel(),
          Spacer(),
          StepBackwardButton(),
          AppIconButton(
            icon: timeline.playing
                ? FontAwesomeIcons.pause
                : FontAwesomeIcons.play,
            onTap: timeline.playing ? timeline.pause : timeline.play,
          ),
          StepForwardButton(),
        ],
      ),
    );
  }
}
