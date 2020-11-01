import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';

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
    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mooltik',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          accentColor: Colors.amber,
          dialogBackgroundColor: Colors.grey[800],
          highlightColor: Colors.white.withOpacity(0.2),
        ),
        initialRoute: '/editor',
        routes: {
          '/': (context) => Text('home page'),
          EditorPage.routeName: (context) => EditorPage(),
        },
      ),
    );
  }
}
