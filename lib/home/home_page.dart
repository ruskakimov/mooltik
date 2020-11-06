import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/editor_page.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:mooltik/projects_manager.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProjectsManagerModel manager = ProjectsManagerModel();

  @override
  void initState() {
    super.initState();
    _initProjectsManager();
  }

  Future<void> _initProjectsManager() async {
    if (await Permission.storage.request().isGranted) {
      final Directory dir = await getApplicationDocumentsDirectory();
      await manager.init(dir);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectsManagerModel>.value(
      value: manager,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ProjectGallery(),
        floatingActionButton: AddProjectButton(
          onPressed: manager.addProject,
        ),
      ),
    );
  }
}

class ProjectGallery extends StatelessWidget {
  const ProjectGallery({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        FontAwesomeIcons.plus,
        size: 18,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: onPressed,
    );
  }
}
