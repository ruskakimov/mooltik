import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
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
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.5,
              actions: [
                SlideAction(
                  child: Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: LabeledIconButton(
                      icon: FontAwesomeIcons.fireAlt,
                      label: 'Destroy',
                      color: Colors.white,
                      onTap: () {},
                    ),
                  ),
                )
              ],
              child: Padding(
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
              ),
            )
        ],
      ),
    );
  }
}
