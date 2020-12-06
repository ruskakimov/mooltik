import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/drawing_page.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';
import 'package:mooltik/editor/timeline/timeline_panel.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';

class EditingPage extends StatelessWidget {
  static const routeName = '/editor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExitButton(context),
                  Spacer(),
                  Preview(),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: TimelinePanel(),
            ),
          ],
        ),
      ),
    );
  }

  AppIconButton _buildExitButton(BuildContext context) {
    return AppIconButton(
      icon: FontAwesomeIcons.arrowLeft,
      onTap: () async {
        final project = context.read<Project>();
        await project.save();
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          project.close();
        });
      },
    );
  }
}

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final project = context.watch<Project>();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: project,
              child: DrawingPage(),
            ),
          ),
        );
      },
      child: FrameThumbnail(frame: project.frames.first),
    );
  }
}
