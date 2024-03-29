import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/home/ui/bin/bin_button.dart';
import 'package:mooltik/home/ui/discord_sliver.dart';
import 'package:mooltik/home/ui/help/help_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'ui/logo.dart';
import 'ui/project_list.dart';
import 'data/gallery_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gallery = GalleryModel();
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _initProjectsManager();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _initProjectsManager() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    await gallery.init(dir);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GalleryModel>.value(value: gallery),
        ChangeNotifierProvider<ScrollController>.value(value: controller),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              leading: Logo(),
              title: Text('Mooltik'),
              titleSpacing: 4,
              centerTitle: false,
              actions: [HelpButton(), BinButton()],
              backgroundColor: Theme.of(context).colorScheme.surface,
              floating: true,
            ),
            DiscordSliver(),
            SliverSafeArea(
              top: false,
              sliver: ProjectList(),
            ),
          ],
        ),
      ),
    );
  }
}
