import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';

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
          AppIconButton(
            icon: FontAwesomeIcons.play,
          ),
        ],
      ),
    );
  }
}
