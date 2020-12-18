import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';

class RecordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      // selected: recording,
      icon: FontAwesomeIcons.microphone,
      onTap: () {},
    );
  }
}
