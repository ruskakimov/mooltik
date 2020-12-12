import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawing_actionbar.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';

class DrawingPage extends StatelessWidget {
  static const routeName = '/draw';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ToolboxModel(),
        ),
      ],
      builder: (context, child) {
        final reel = context.watch<TimelineModel>();

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: reel.selectedFrame),
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
                    child: DrawingActionbar(),
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
