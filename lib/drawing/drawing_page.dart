import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/drawing_page_options_model.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/drawing_actionbar.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/fit_to_screen_button.dart';
import 'package:mooltik/drawing/ui/lasso/lasso_menu.dart';
import 'package:mooltik/drawing/ui/reel/frame_reel.dart';
import 'package:mooltik/drawing/ui/layers/layer_button.dart';
import 'package:mooltik/editing/data/timeline/timeline_model.dart';
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
          create: (context) => DrawingPageOptionsModel(
            context.read<SharedPreferences>(),
          ),
        ),
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
            );
          },
        ),
      ],
      builder: (context, child) {
        final reelStack = context.watch<ReelStackModel>();

        final twoRowHeader = MediaQuery.of(context).size.width < (9 * 52);
        final headerHeight = twoRowHeader ? 88.0 : 44.0;

        final safePadding = MediaQuery.of(context).padding;

        return WillPopScope(
          // Disables iOS swipe back gesture. (https://github.com/flutter/flutter/issues/14203)
          onWillPop: () async => true,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<FrameReelModel>.value(
                  value: reelStack.activeReel,
                ),
                ChangeNotifierProxyProvider<FrameReelModel, OnionModel>(
                  update: (context, reel, model) => model!
                    ..updateFrames(reel.frameSeq)
                    ..updateSelectedIndex(reel.currentIndex),
                  create: (context) => OnionModel(
                    frames: context.read<FrameReelModel>().frameSeq,
                    selectedIndex: context.read<FrameReelModel>().currentIndex,
                    sharedPreferences: context.read<SharedPreferences>(),
                  ),
                ),
                ChangeNotifierProxyProvider2<FrameReelModel, ToolboxModel,
                    EaselModel>(
                  create: (context) => EaselModel(
                    image: context.read<FrameReelModel>().currentFrame.image,
                    selectedTool: context.read<ToolboxModel>().selectedTool,
                    sharedPreferences: context.read<SharedPreferences>(),
                  ),
                  update: (_, reel, toolbox, easel) => easel!
                    ..updateImage(reel.currentFrame.image)
                    ..updateSelectedTool(toolbox.selectedTool),
                ),
                ChangeNotifierProxyProvider<EaselModel, LassoModel>(
                  create: (context) => LassoModel(
                    lasso: context.read<ToolboxModel>().lasso,
                    easel: context.read<EaselModel>(),
                    headerHeight: headerHeight,
                  ),
                  update: (_, easel, lasso) => lasso!
                    ..updateEasel(easel)
                    ..updateHeaderHeight(headerHeight),
                ),
              ],
              child: Stack(
                children: [
                  Positioned.fill(
                    top: headerHeight,
                    child: Easel(),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: DrawingActionbar(
                      twoRow: twoRowHeader,
                      height: headerHeight,
                    ),
                  ),
                  Positioned(
                    top: headerHeight + safePadding.top,
                    right: safePadding.right,
                    child: FitToScreenButton(),
                  ),
                  if (context.watch<DrawingPageOptionsModel>().showFrameReel)
                    Positioned(
                      bottom: safePadding.bottom,
                      left: 0,
                      right: 0,
                      child: FrameReel(),
                    ),
                  Positioned(
                    bottom: 60 + safePadding.bottom,
                    right: 4 + safePadding.right,
                    child: LayerButton(),
                  ),
                  Positioned.fill(
                    top: headerHeight + safePadding.top,
                    left: safePadding.left,
                    right: safePadding.right,
                    bottom: safePadding.bottom,
                    child: LassoMenu(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
