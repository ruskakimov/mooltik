import 'package:flutter/material.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();

    return CustomPaint();
  }
}
