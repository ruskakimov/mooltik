import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/play_mode_button.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_end_handle.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/resize_start_handle.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/scene_end_handle.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/ui/timeline/view/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/playhead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerModel>(
          create: (context) => PlayerModel(
            soundClips: context.read<Project>().soundClips,
            timeline: context.read<TimelineModel>(),
          ),
        ),
        ChangeNotifierProvider<TimelineViewModel>(
          create: (context) => TimelineViewModel(
            timeline: context.read<TimelineModel>(),
            sharedPreferences: context.read<SharedPreferences>(),
            createNewFrame: context.read<Project>().createNewFrame,
          ),
        ),
      ],
      builder: (context, child) {
        final timelineView = context.watch<TimelineViewModel>();

        return Material(
          elevation: 0,
          child: Column(
            children: [
              TimelineActionbar(),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TimelineView(),
                    Playhead(),
                    if (timelineView.showSliverMenu &&
                        timelineView.selectedSliverIndex != 0)
                      ResizeStartHandle(),
                    if (timelineView.isEditingScene) SceneEndHandle(),
                    if (timelineView.isEditingScene) PlayModeButton(),
                    if (timelineView.showSliverMenu) ResizeEndHandle(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
