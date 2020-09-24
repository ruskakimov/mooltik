import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:provider/provider.dart';

import 'editor/editor_page.dart';
import 'editor/timeline/timeline_model.dart';
import 'editor/toolbox/toolbox_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove system top and bottom bars.
  SystemChrome.setEnabledSystemUIOverlays([]);

  // Lock to portrait mode.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mooltik',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        dialogBackgroundColor: Colors.blueGrey[900],
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TimelineModel(
              initialKeyframes: [FrameModel(1)],
            ),
          ),
          ChangeNotifierProvider(create: (context) => ToolboxModel()),
        ],
        child: EditorPage(),
      ),
    );
  }
}
