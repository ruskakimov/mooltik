import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawing_page.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final project = context.read<Project>();
        final timeline = context.read<TimelineModel>();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: project),
                ChangeNotifierProvider.value(value: timeline),
              ],
              child: DrawingPage(),
            ),
          ),
        );
      },
      child: FrameThumbnail(
        frame: context.select<TimelineModel, FrameModel>(
          (timeline) => timeline.selectedFrame,
        ),
      ),
    );
  }
}
