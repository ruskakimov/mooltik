import 'dart:async';
import 'dart:io' show Platform;
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/common/data/copy_paster_model.dart';
import 'package:mooltik/common/ui/orientation_listener.dart';
import 'package:mooltik/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  void setPreferredSystemUI() {
    final window = WidgetsBinding.instance!.window;
    final size = window.physicalSize / window.devicePixelRatio;
    final isPortrait = size.width < size.height;
    final isMobile = size.width < 600;
    final isIPad = Platform.isIOS && !isMobile;
    final isIPhone = Platform.isIOS && isMobile;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        // Show top system bar:
        // - to not build UI under multitasking dots in iPadOS 15
        // - notch area cannot be utilized by UI anyway on iPhone
        if (isIPad || (isIPhone && isPortrait)) SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  setPreferredSystemUI();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await Firebase.initializeApp();

  runZonedGuarded(() async {
    // Enable Crashlytics in non-debug mode.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError?.call(errorDetails);
    };

    runApp(
      OrientationListener(
        onOrientationChanged: (_) => setPreferredSystemUI(),
        child: App(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);

  // Catch errors that happen outside of the Flutter context.
  // Source: https://firebase.flutter.dev/docs/crashlytics/usage#errors-outside-of-flutter
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
  const App({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

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
              onPrimary: Colors.grey[900]!,
              primaryVariant: Colors.amberAccent,
              // Secondary
              secondary: Colors.grey[600]!,
              onSecondary: Colors.white,
              secondaryVariant: Colors.grey[800]!,
              // Surface
              surface: Colors.grey[850]!,
              onSurface: Colors.grey[100]!,
              // Background
              background: Colors.grey[900]!,
              onBackground: Colors.grey[100]!,
              // Error
              error: Colors.redAccent,
              onError: Colors.white,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
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
