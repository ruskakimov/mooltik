import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/drawing_page.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
import 'package:mooltik/editor/timeline/timeline_panel.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';

import 'reel/reel_model.dart';

class EditingPage extends StatelessWidget {
  static const routeName = '/editor';

  const EditingPage({
    Key key,
    @required this.reel,
  }) : super(key: key);

  final ReelModel reel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: reel,
          ),
          ChangeNotifierProvider(
            create: (context) => ToolboxModel(),
          ),
        ],
        builder: (context, child) {
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
        });
  }

  AppIconButton _buildExitButton(BuildContext context) {
    return AppIconButton(
      icon: FontAwesomeIcons.arrowLeft,
      onTap: () async {
        final project = context.read<Project>();
        await project.save();
        project.close();
        Navigator.pop(context);
      },
    );
  }
}

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DrawingPage(reel: reel),
          ),
        );
      },
      child: FrameThumbnail(frame: reel.selectedFrame),
    );
  }
}
