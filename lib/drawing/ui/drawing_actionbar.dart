import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/surface.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/tool_button.dart';
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
            icon: FontAwesomeIcons.ellipsisV,
            onTap: () {},
          ),
          // AppIconButton(
          //   icon: FontAwesomeIcons.lightbulb,
          //   selected: context.watch<OnionModel>().enabled,
          //   onTap: () {
          //     context.read<OnionModel>().toggle();
          //   },
          // ),
          Spacer(),
          for (final tool in toolbox.tools)
            ToolButton(
              tool: tool,
              selected: tool == toolbox.selectedTool,
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
