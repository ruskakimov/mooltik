import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/exporter_model.dart';
import 'package:mooltik/editing/ui/actionbar/export_dialog.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';

class EditingActionbar extends StatelessWidget {
  const EditingActionbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppIconButton(
          icon: FontAwesomeIcons.arrowLeft,
          onTap: () async {
            final project = context.read<Project>();
            await project.save();
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              project.close();
            });
          },
        ),
        Spacer(),
        AppIconButton(
          icon: FontAwesomeIcons.fileDownload,
          onTap: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => ChangeNotifierProvider(
              create: (context) => ExporterModel(
                frames: context.read<Project>().frames,
                soundClips: context.read<Project>().soundClips,
              ),
              child: ExportDialog(),
            ),
          ),
        ),
      ],
    );
  }
}
