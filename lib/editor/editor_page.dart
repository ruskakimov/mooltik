import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/editor_drawer.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';
import 'timeline/timeline_model.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    final toolbox = context.watch<ToolboxModel>();

    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: MultiProvider(
        providers: [
          // TODO: Frame is provided here since undo/redo buttons listen to it. Consider removing when undo stack is extracted and generalized.
          ChangeNotifierProvider.value(value: timeline.visibleKeyframe),
          ChangeNotifierProxyProvider2<TimelineModel, ToolboxModel, EaselModel>(
            create: (_) => EaselModel(
              frame: timeline.selectedKeyframe,
              // TODO: Pass frame width/height from a single source.
              frameWidth: timeline.visibleKeyframe.width,
              frameHeight: timeline.visibleKeyframe.height,
              selectedTool: toolbox.selectedTool,
              createFrame: timeline.createKeyframeAtSelectedNumber,
            ),
            update: (_, timeline, toolbox, easel) => easel
              ..updateFrame(timeline.selectedKeyframe)
              ..updateSelectedTool(toolbox.selectedTool),
          ),
        ],
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: Easel(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: EditorDrawer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
