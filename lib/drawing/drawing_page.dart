import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/drawing_actionbar.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/frame_reel.dart';
import 'package:mooltik/drawing/ui/layers/layer_button.dart';
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
        ChangeNotifierProvider(
          create: (context) => ToolboxModel(
            context.read<SharedPreferences>(),
          ),
        ),
        ChangeNotifierProvider<ReelStackModel>(
          create: (context) {
            // Read current frame to reset `frameSeq.currentIndex`.
            // This index can get out of sync because of VideoSliver rendering.
            context.read<TimelineModel>().currentFrame;

            return ReelStackModel(
              scene: context.read<TimelineModel>().currentScene,
              sharedPreferences: context.read<SharedPreferences>(),
            );
          },
        ),
      ],
      builder: (context, child) {
        final reelStack = context.watch<ReelStackModel>();

        return WillPopScope(
          // Disables iOS swipe back gesture. (https://github.com/flutter/flutter/issues/14203)
          onWillPop: () async => true,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: reelStack.activeReel),
                ChangeNotifierProxyProvider<FrameReelModel, OnionModel>(
                  update: (context, reel, model) =>
                      model..updateSelectedIndex(reel.currentIndex),
                  create: (context) => OnionModel(
                    frames: context.read<FrameReelModel>().frameSeq,
                    selectedIndex: context.read<FrameReelModel>().currentIndex,
                    sharedPreferences: context.read<SharedPreferences>(),
                  ),
                ),
                ChangeNotifierProxyProvider2<FrameReelModel, ToolboxModel,
                    EaselModel>(
                  create: (context) => EaselModel(
                      frame: context.read<FrameReelModel>().currentFrame,
                      selectedTool: context.read<ToolboxModel>().selectedTool,
                      onChanged: (Frame frame) {
                        context
                            .read<FrameReelModel>()
                            .replaceCurrentFrame(frame);
                      }),
                  update: (_, reel, toolbox, easel) => easel
                    ..updateFrame(reel.currentFrame)
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
                      child: DrawingActionbar(),
                    ),
                    if (reelStack.showFrameReel)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 44,
                        child: FrameReel(),
                      ),
                    Positioned(
                      bottom: 48,
                      right: 4,
                      child: LayerButton(),
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
