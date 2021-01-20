import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
            PortalEntry(
              visible: toolbox.tools[i] == toolbox.selectedTool,
              portal: Container(
                width: 150,
                height: 50,
                color: Colors.red,
              ),
              portalAnchor: Alignment.topCenter,
              child: AppIconButton(
                icon: toolbox.tools[i].icon,
                selected: toolbox.tools[i] == toolbox.selectedTool,
                onTap: () {
                  toolbox.selectTool(i);
                },
              ),
              childAnchor: Alignment.bottomCenter.add(Alignment(0, -0.2)),
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
