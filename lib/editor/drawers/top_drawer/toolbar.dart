import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < toolbox.tools.length; i++)
          DrawerIconButton(
            icon: toolbox.tools[i].icon,
            selected: toolbox.tools[i] == toolbox.selectedTool,
            onTap: () => toolbox.selectTool(i),
          ),
      ],
    );
  }
}
