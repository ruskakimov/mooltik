import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawing_actionbar.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';
import 'reel/reel_model.dart';

class DrawingPage extends StatelessWidget {
  static const routeName = '/draw';

  const DrawingPage({
    Key key,
    this.initialFrameIndex = 0,
  })  : assert(initialFrameIndex != null),
        super(key: key);

  final int initialFrameIndex;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ReelModel(
            frameSize: context.read<Project>().frameSize,
            frames: context.read<Project>().frames,
            initialFrameIndex: initialFrameIndex,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ToolboxModel(),
        ),
      ],
      builder: (context, child) {
        final reel = context.watch<ReelModel>();

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
