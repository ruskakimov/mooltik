import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/timeline/player_model.dart';

class RecordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerModel>();

    return AppIconButton(
      selected: player.recording,
      icon: FontAwesomeIcons.microphone,
      onTap: player.recording ? player.stopRecording : player.startRecording,
    );
  }
}
