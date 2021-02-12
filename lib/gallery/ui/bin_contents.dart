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
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        children: [
          for (final project in binnedProjects)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color:
                      Colors.white, // in case thumbnail is missing background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(project.thumbnail),
              ),
            )
        ],
      ),
    );
  }
}
