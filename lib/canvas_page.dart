import 'package:flutter/material.dart';

import 'painter.dart';

class CanvasPage extends StatefulWidget {
  CanvasPage({Key key}) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
    );
  }
}
