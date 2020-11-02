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
          // Overscroll
          accentColor: Colors.amber,
          // Splash
          highlightColor: Colors.white.withOpacity(0.2),
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            // Primary
            primary: Colors.amber,
            onPrimary: Colors.grey[900],
            primaryVariant: Colors.amberAccent,
            // Secondary
            secondary: Colors.grey[600],
            onSecondary: Colors.white,
            secondaryVariant: Colors.grey[800],
            // Surface
            surface: Colors.grey[850],
            onSurface: Colors.grey[100],
            // Background
            background: Colors.grey[900],
            onBackground: Colors.grey[100],
            // Error
            error: Colors.redAccent,
            onError: Colors.white,
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
