import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'editor/editor_page.dart';
import 'editor/timeline.dart';
import 'editor/toolbox.dart';

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
      title: 'Animation app',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Timeline()),
          ChangeNotifierProvider(create: (context) => Toolbox()),
        ],
        child: EditorPage(),
      ),
    );
  }
}
