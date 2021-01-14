import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/drawing_actionbar.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/size_picker.dart';
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

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider<FrameModel>.value(
                value: timeline.selectedFrame,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizePicker(),
                    ),
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
