import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/get_permission.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/export/export_dialog.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';

class EditingActionbar extends StatelessWidget {
  const EditingActionbar({
    Key? key,
    this.title,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final Text? title;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final playing = context.select<TimelineModel, bool>(
      (timeline) => timeline.isPlaying,
    );

    return Flex(
      direction: direction,
      children: [
        AppIconButton(
          icon: FontAwesomeIcons.arrowLeft,
          onTap: playing ? null : () => Navigator.maybePop(context),
        ),
        Spacer(),
        title!,
        Spacer(),
        AppIconButton.svg(
          svgPath: 'assets/icons/export.svg',
          onTap: playing
              ? null
              : () => getPermission(
                    context: context,
                    permission: Permission.storage,
                    onGranted: () => _openExportDialog(context),
                  ),
        ),
      ],
    );
  }

  Future<void> _openExportDialog(BuildContext context) async {
    final tempDir = await getTemporaryDirectory();
    final project = context.read<Project>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => ChangeNotifierProvider(
        create: (context) => ExporterModel(
          frames: project.exportFrames,
          soundClips: project.soundClips,
          tempDir: tempDir,
        ),
        child: ExportDialog(),
      ),
    );
  }
}
