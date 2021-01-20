import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/surface.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/step_backward_button.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/step_forward_button.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class DrawingActionbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final easel = context.watch<EaselModel>();

    return Surface(
      child: Row(
        children: <Widget>[
          AppIconButton(
            icon: FontAwesomeIcons.arrowLeft,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          AppIconButton(
            icon: FontAwesomeIcons.lightbulb,
            selected: context.watch<OnionModel>().enabled,
            onTap: () {
              context.read<OnionModel>().toggle();
            },
          ),
          Spacer(),
          for (var i = 0; i < toolbox.tools.length; i++)
            AppIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              onTap: () {
                toolbox.selectTool(i);
              },
            ),
          Spacer(),
          AppIconButton(
            icon: FontAwesomeIcons.undo,
            onTap: easel.undoAvailable ? easel.undo : null,
          ),
          AppIconButton(
            icon: FontAwesomeIcons.redo,
            onTap: easel.redoAvailable ? easel.redo : null,
          ),
        ],
      ),
    );
  }
}
