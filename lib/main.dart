import 'package:flutter/material.dart';

import 'editor_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation tool',
      home: EditorPage(),
    );
  }
}
