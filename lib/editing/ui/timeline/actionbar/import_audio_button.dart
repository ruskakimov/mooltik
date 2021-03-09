import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/importer_model.dart';

class ImportAudioButton extends StatelessWidget {
  const ImportAudioButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: FontAwesomeIcons.music,
      onTap: () async {
        try {
          final project = context.read<Project>();
          await ImporterModel().importAudioTo(project);
        } catch (e) {
          final snack = SnackBar(
            content: Text(
              'Failed to load audio.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
    );
  }
}
