import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/drawing_actionbar.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/frame_button.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/ui/easel/easel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingPage extends StatelessWidget {
  static const routeName = '/draw';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<TimelineModel, OnionModel>(
          update: (context, timeline, model) =>
              model..updateSelectedIndex(timeline.selectedFrameIndex),
          create: (context) => OnionModel(
            frames: context.read<TimelineModel>().frames,
            selectedIndex: context.read<TimelineModel>().selectedFrameIndex,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ToolboxModel(context.read<SharedPreferences>()),
        ),
      ],
      builder: (context, child) {
        final timeline = context.watch<TimelineModel>();

        return WillPopScope(
          // Disables iOS swipe back gesture. (https://github.com/flutter/flutter/issues/14203)
          onWillPop: () async => true,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<FrameModel>.value(
                  value: timeline.selectedFrame,
                ),
                ChangeNotifierProxyProvider2<TimelineModel, ToolboxModel,
                    EaselModel>(
                  create: (context) => EaselModel(
                    frame: timeline.selectedFrame,
                    frameSize: context.read<Project>().frameSize,
                    selectedTool: context.read<ToolboxModel>().selectedTool,
                  ),
                  update: (_, reel, toolbox, easel) => easel
                    ..updateFrame(reel.selectedFrame)
                    ..updateSelectedTool(toolbox.selectedTool),
                ),
              ],
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 44.0),
                        child: Easel(),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 44,
                      child: DrawingActionbar(),
                    ),
                    if (timeline.stepBackwardAvailable)
                      Positioned(
                        bottom: 16,
                        left: 8,
                        child: FrameButton(
                          frame: timeline.frameBeforeSelected,
                          onTap: timeline.stepBackward,
                        ),
                      ),
                    if (timeline.stepForwardAvailable)
                      Positioned(
                        bottom: 16,
                        right: 8,
                        child: FrameButton(
                          frame: timeline.frameAfterSelected,
                          onTap: timeline.stepForward,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
