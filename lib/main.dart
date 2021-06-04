import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/common/data/copy_paster_model.dart';
import 'package:mooltik/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove system top bar.
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await Firebase.initializeApp();

  runZonedGuarded(() async {
    // Enable Crashlytics in non-debug mode.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    runApp(App(
      sharedPreferences: await SharedPreferences.getInstance(),
    ));
  }, FirebaseCrashlytics.instance.recordError);

  // Catch errors that happen outside of the Flutter context.
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
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
        ChangeNotifierProvider(create: (context) => CopyPasterModel()),
      ],
      child: Portal(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mooltik',
          theme: ThemeData(
            // Overscroll
            accentColor: Colors.white38,
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
