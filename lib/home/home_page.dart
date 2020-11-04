import 'package:flutter/material.dart';
import 'package:mooltik/editor/editor_page.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: GestureDetector(
            onTap: () {
              // TODO: Read files here.
              // TODO: Pass frames.
              Navigator.of(context).pushNamed(EditorPage.routeName);
            },
            child: CustomPaint(
              size: Size(200, 200),
              painter: FramePainter(
                // TODO: First project frame.
                frame: FrameModel(size: Size(200, 200)),
              ),
            )),
      ),
    );
  }
}
