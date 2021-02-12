import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                _BinSlideAction(
                  color: Colors.red,
                  icon: FontAwesomeIcons.fireAlt,
                  label: 'Destroy',
                  onTap: () {},
                ),
              ],
              secondaryActions: [
                _BinSlideAction(
                  icon: FontAwesomeIcons.undoAlt,
                  label: 'Restore',
                  onTap: () {},
                ),
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

class _BinSlideAction extends StatelessWidget {
  const _BinSlideAction({
    Key key,
    @required this.icon,
    @required this.label,
    this.color,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: LabeledIconButton(
          icon: icon,
          label: label,
          color: Colors.white,
          onTap: onTap,
        ),
      ),
    );
  }
}
