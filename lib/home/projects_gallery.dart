import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/editor_page.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:mooltik/home/projects_manager_model.dart';

class ProjectGallery extends StatelessWidget {
  const ProjectGallery({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProjectsManagerModel>();

    return Center(
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
        ),
      ),
    );
  }
}
