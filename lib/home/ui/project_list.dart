import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/home/ui/add_project_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/editing_page.dart';

import 'project_thumbnail.dart';
import '../data/gallery_model.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({
    Key key,
  }) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  bool _openingProject = false;

  @override
  Widget build(BuildContext context) {
    final gallery = context.watch<GalleryModel>();
    final projects = gallery.projects;

    return SliverPadding(
      padding: const EdgeInsets.all(32),
      sliver: SliverGrid.count(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 32,
        crossAxisSpacing: 24,
        children: [
          AddProjectButton(),
          for (final project in projects)
            ChangeNotifierProvider<Project>.value(
              key: Key('${project.creationEpoch}'),
              value: project,
              child: ProjectThumbnail(
                thumbnail: project.thumbnail,
                onTap: () async {
                  try {
                    await _openProject(context, project);
                  } catch (e) {
                    _showErrorSnackbar(context, e);
                  } finally {
                    Future.delayed(
                      Duration(milliseconds: 500),
                      () => _openingProject = false,
                    );
                  }
                },
              ),
            )
        ],
      ),
    );
  }

  Future<void> _openProject(BuildContext context, Project project) async {
    if (_openingProject) return;
    _openingProject = true;

    await project.open();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<Project>.value(
          value: project,
          child: EditingPage(),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, dynamic e) {
    final snackBar = SnackBar(
      content: Text(
        'Oops, could not read project data.',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'OPEN LOG',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error log'),
              content: SelectableText(e.toString()),
            ),
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
