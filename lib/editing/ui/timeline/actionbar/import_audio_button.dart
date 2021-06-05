import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/importer_model.dart';

class ImportAudioButton extends StatelessWidget {
  const ImportAudioButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImporterModel(),
      builder: (context, _) {
        final importer = context.watch<ImporterModel>();
        final playing = context.select<TimelineModel, bool>(
          (timeline) => timeline.isPlaying,
        );

        if (importer.importing) {
          return SizedBox(
            width: 52,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return AppIconButton(
          icon: FontAwesomeIcons.music,
          onTap: playing
              ? null
              : () async {
                  try {
                    final project = context.read<Project>();
                    await importer.importAudioTo(project);
                  } catch (e) {
                    _showFailedImportError(context);
                  }
                },
        );
      },
    );
  }

  void _showFailedImportError(BuildContext context) {
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
}
