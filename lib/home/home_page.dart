import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/home/ui/discord_sliver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'ui/home_bar.dart';
import 'ui/project_list.dart';
import 'data/gallery_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: CustomScrollView(
                slivers: [
                  DiscordSliver(),
                  ProjectList(),
                ],
              ),
            ),
            HomeBar(),
          ],
        ),
      ),
    );
  }
}
