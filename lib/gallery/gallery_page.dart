import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/gallery/ui/add_project_button.dart';
import 'package:mooltik/gallery/ui/home_bar.dart';
import 'package:mooltik/gallery/ui/project_list.dart';
import 'package:mooltik/gallery/data/gallery_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GalleryModel manager = GalleryModel();

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
    return ChangeNotifierProvider<GalleryModel>.value(
      value: manager,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: ProjectList(),
            ),
            HomeBar(),
          ],
        ),
        floatingActionButton: AddProjectButton(),
      ),
    );
  }
}
