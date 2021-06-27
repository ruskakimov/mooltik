import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/get_permission.dart';
import 'package:mooltik/editing/data/exporter_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/actionbar/export_dialog.dart';
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

enum ExportOption {
  video,
  images,
}

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportOption _selectedOption = ExportOption.video;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Export as'),
      contentPadding: const EdgeInsets.all(16),
      children: [
        CupertinoSlidingSegmentedControl<ExportOption>(
          backgroundColor: Colors.black.withOpacity(0.25),
          // backgroundColor: Theme.of(context).colorScheme.secondary,
          // thumbColor: Theme.of(context).colorScheme.primary,
          // padding: const EdgeInsets.all(4),
          groupValue: _selectedOption,
          children: {
            ExportOption.video: Text('Video'),
            ExportOption.images: Text('Images'),
          },
          onValueChanged: (option) {
            if (option == null) return;
            setState(() {
              _selectedOption = option;
            });
          },
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            labelText: 'File name',
          ),
          controller: TextEditingController.fromValue(
            TextEditingValue(text: '123123.mp4'),
          ),
          maxLines: 1,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Export'),
        ),
      ],
    );
  }
}
