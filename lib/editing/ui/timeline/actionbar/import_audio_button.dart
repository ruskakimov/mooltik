import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/open_allow_access_dialog.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:permission_handler/permission_handler.dart';
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
          onTap: playing ? null : () => _handleImportAudioTap(context),
        );
      },
    );
  }

  Future<void> _handleImportAudioTap(BuildContext context) async {
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      _importAudio(context);
    } else if (storageStatus.isPermanentlyDenied) {
      openAllowAccessDialog(context: context, name: 'Storage');
    }
  }

  Future<void> _importAudio(BuildContext context) async {
    final importer = context.read<ImporterModel>();
    final project = context.read<Project>();

    try {
      await importer.importAudioTo(project);
    } catch (e, stack) {
      _showFailedAudioImportSnack(context);
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void _showFailedAudioImportSnack(BuildContext context) {
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
