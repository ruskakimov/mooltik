import 'package:flutter/material.dart';
import 'package:mooltik/gallery/data/gallery_model.dart';
import 'package:provider/provider.dart';

class BinContents extends StatelessWidget {
  const BinContents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = context.watch<GalleryModel>();
    final binnedProjects = gallery.binnedProjects;

    return SizedBox(
      width: 200,
      height: 300,
      child: ListView(
        children: [
          for (final project in binnedProjects) Image.file(project.thumbnail)
        ],
      ),
    );
  }
}
