import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove system top bar.
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await Firebase.initializeApp();

  // Disable crashlytics in debug mode.
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  runApp(App(
    sharedPreferences: await SharedPreferences.getInstance(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  const App({Key key, this.sharedPreferences}) : super(key: key);

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: sharedPreferences),
        Provider<RouteObserver>.value(value: routeObserver),
      ],
      child: Portal(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mooltik',
          theme: ThemeData(
            // Overscroll
            accentColor: Colors.amber,
            // Splash
            splashColor: Colors.white30,
            highlightColor: Colors.white.withOpacity(0.2),
            // Switch
            toggleableActiveColor: Colors.amber,
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
          navigatorObservers: [routeObserver],
          routes: {
            Navigator.defaultRouteName: (context) => HomePage(),
          },
        ),
      ),
    );
  }
}
