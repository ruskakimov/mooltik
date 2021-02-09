import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/gallery/ui/project_thumbnail.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/editing_page.dart';
import 'package:mooltik/gallery/data/gallery_model.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = context.watch<GalleryModel>();

    if (gallery.numberOfProjects == null) return SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      scrollDirection: Axis.horizontal,
      itemCount: gallery.numberOfProjects,
      itemBuilder: (context, index) {
        final Project project = gallery.getProject(index);

        return Center(
          key: Key('${project.id}'),
          child: ChangeNotifierProvider<Project>.value(
            value: project,
            child: ProjectThumbnail(
              thumbnail: project.thumbnail,
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
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 24),
    );
  }
}
