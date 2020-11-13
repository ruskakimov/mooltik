import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/toolbar.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'easel/easel.dart';
import 'reel/reel_model.dart';

class EditorPage extends StatelessWidget {
  static const routeName = '/editor';

  const EditorPage({
    Key key,
    @required this.reel,
  }) : super(key: key);

  final ReelModel reel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: reel,
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
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: reel.playing ? 0 : 1,
                        child: ToolBar(),
                      ),
                    ),
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
