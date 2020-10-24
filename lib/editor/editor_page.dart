import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/action_bar.dart';
import 'package:mooltik/editor/drawer/toolbar.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';
import 'reel/reel_model.dart';

class EditorPage extends StatelessWidget {
  static const routeName = '/editor';

  const EditorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ReelModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ToolboxModel(),
          ),
        ],
        builder: (context, child) {
          final reel = context.watch<ReelModel>();

          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: MultiProvider(
              providers: [
                // TODO: Frame is provided here since undo/redo buttons listen to it. Consider removing when undo stack is extracted and generalized.
                ChangeNotifierProvider.value(value: reel.visibleFrame),
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
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: reel.playing ? 0 : 1,
                        child: ToolBar(),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: AnimatedOpacity(
                    //       duration: Duration(milliseconds: 200),
                    //       opacity: reel.playing ? 0 : 1,
                    //       child: ActionBar()),
                    // ),
                    if (reel.playing)
                      Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerUp: (_) => reel.stop(),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
