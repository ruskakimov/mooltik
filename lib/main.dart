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
          highlightColor: Colors.white.withOpacity(0.2),
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.amber,
            primaryVariant: Colors.amberAccent,
            secondary: Colors.grey[700],
            secondaryVariant: Colors.grey[800],
            surface: Colors.grey[850],
            background: Colors.grey[900],
            error: Colors.redAccent,
            onPrimary: Colors.white,
            onBackground: Colors.white,
            onError: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white,
          ),
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
