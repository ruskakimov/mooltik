import 'package:flutter/material.dart';
import 'package:mooltik/editing/editing_page.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/gallery_model.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white12,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _addProject(context),
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white24,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.plus, size: 20),
                SizedBox(height: 12),
                Text('Add Project'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addProject(BuildContext context) async {
    final manager = context.read<GalleryModel>();

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
  }
}
