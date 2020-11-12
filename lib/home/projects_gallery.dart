import 'package:flutter/material.dart';
import 'package:mooltik/home/project.dart';
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

    if (manager.numberOfProjects == null) return Container();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      scrollDirection: Axis.horizontal,
      itemCount: manager.numberOfProjects,
      itemBuilder: (context, index) {
        final Project project = manager.getProject(index);

        return Center(
          child: GestureDetector(
            onTap: () async {
              await project.open();
              // TODO: Pass reel to editor.
              Navigator.of(context).pushNamed(EditorPage.routeName);
            },
            onLongPress: () {
              manager.deleteProject(index);
            },
            child: ProjectThumbnail(
              project: project,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 24),
    );
  }
}

class ProjectThumbnail extends StatelessWidget {
  const ProjectThumbnail({
    Key key,
    @required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${project.id}'),
        CustomPaint(
          size: Size(200, 200),
          painter: FramePainter(
            // TODO: First project frame.
            frame: FrameModel(size: Size(200, 200)),
          ),
        ),
      ],
    );
  }
}