import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class AddSceneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    return AppIconButton(
      icon: FontAwesomeIcons.plus,
      onTap: timeline.isPlaying ? null : () => _addSceneAfterCurrent(context),
    );
  }

  Future<void> _addSceneAfterCurrent(BuildContext context) async {
    final newScene = await context.read<Project>().createNewScene();
    final scenes = context.read<TimelineModel>().sceneSeq;
    scenes.insert(scenes.currentIndex + 1, newScene);
  }
}
