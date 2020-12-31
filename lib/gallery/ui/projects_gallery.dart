import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/editing_page.dart';
import 'package:mooltik/gallery/data/projects_manager_model.dart';

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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<Project>.value(
                    value: project,
                    child: EditingPage(),
                  ),
                ),
              );
            },
            child: ChangeNotifierProvider<Project>.value(
              value: project,
              child: ProjectThumbnail(thumbnail: project.thumbnail),
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
    @required this.thumbnail,
  }) : super(key: key);

  final File thumbnail;

  @override
  Widget build(BuildContext context) {
    context.watch<Project>();

    return Container(
      width: 200,
      height: 200,
      color: Colors.white,
      child: thumbnail.existsSync()
          ? Image.memory(
              // Temporary fix for this issue https://github.com/flutter/flutter/issues/17419
              thumbnail.readAsBytesSync(),
              fit: BoxFit.cover,
            )
          : null,
    );
  }
}
