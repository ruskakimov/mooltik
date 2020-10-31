import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'editor/editor_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Remove system top and bottom bars.
  SystemChrome.setEnabledSystemUIOverlays([]);

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
        accentColor: Colors.amber,
        dialogBackgroundColor: Colors.blueGrey[900],
        highlightColor: Colors.white,
      ),
      initialRoute: '/editor',
      routes: {
        '/': (context) => Text('home page'),
        EditorPage.routeName: (context) => EditorPage(),
      },
    );
  }
}
