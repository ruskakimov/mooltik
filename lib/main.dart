import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'editor/editor_model.dart';
import 'editor/editor_page.dart';

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
      home: ChangeNotifierProvider(
        create: (context) => EditorModel(),
        child: EditorPage(),
      ),
    );
  }
}
