import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'editor/editor_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation app',
      home: EditorPage(),
    );
  }
}
