import 'package:flutter/material.dart';

import 'canvas_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Record painting',
      home: Scaffold(
        body: SafeArea(child: CanvasPage()),
      ),
    );
  }
}
