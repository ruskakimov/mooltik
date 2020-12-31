import 'package:flutter/material.dart';
import 'package:mooltik/editing/editing_page.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/gallery/data/gallery_model.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<GalleryModel>();

    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        FontAwesomeIcons.plus,
        size: 18,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: () async {
        final project = await manager.addProject();
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
    );
  }
}
