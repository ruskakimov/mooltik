import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/drawer_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final frame = context.watch<FrameModel>();
    final playing = context.watch<TimelineModel>().playing;

    return ColoredBox(
      color: Colors.blueGrey[900],
      child: Column(
        children: <Widget>[
          for (var i = 0; i < toolbox.tools.length; i++)
            DrawerIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              onTap: () => toolbox.selectTool(i),
            ),
          Spacer(),
          DrawerIconButton(
            icon: FontAwesomeIcons.undo,
            onTap: frame.undoAvailable && !playing ? frame.undo : null,
          ),
          DrawerIconButton(
            icon: FontAwesomeIcons.redo,
            onTap: frame.redoAvailable && !playing ? frame.redo : null,
          ),
        ],
      ),
    );
  }
}
