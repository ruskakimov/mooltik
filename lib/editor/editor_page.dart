import 'package:flutter/material.dart';
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
      body: ChangeNotifierProvider.value(
        value: timeline.selectedFrame,
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
