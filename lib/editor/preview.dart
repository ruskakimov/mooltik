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
    final project = context.watch<Project>();

    return GestureDetector(
      onTap: () {
        final frameIndex = context.read<TimelineModel>().selectedFrameIndex;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: project,
              child: DrawingPage(initialFrameIndex: frameIndex),
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
