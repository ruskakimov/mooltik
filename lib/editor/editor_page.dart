import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';
import 'drawers/bottom_drawer/bottom_drawer.dart';
import 'drawers/top_drawer/top_drawer.dart';
import 'timeline/timeline_model.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: timeline.selectedFrame),
          ChangeNotifierProvider(
            create: (context) => EaselModel(
              frame: timeline.selectedFrame,
              selectedTool: context.read<ToolboxModel>().selectedTool,
            ),
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
                alignment: Alignment.topCenter,
                child: TopDrawer(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomDrawer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
