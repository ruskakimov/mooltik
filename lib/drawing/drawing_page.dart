import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/drawing_actionbar.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/ui/easel/easel.dart';
import 'package:provider/provider.dart';

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
          create: (context) => ToolboxModel(),
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
              child: Column(
                children: [
                  DrawingActionbar(),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned.fill(
                          child: Easel(),
                        ),
                      ],
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
