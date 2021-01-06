import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/player_model.dart';

class RecordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerModel>();

    return AppIconButton(
      selected: player.isRecording,
      icon: FontAwesomeIcons.microphone,
      onTap: player.isRecording ? player.stopRecording : player.startRecording,
    );
  }
}
