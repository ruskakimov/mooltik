import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/ui/color_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/tool_button.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    final toolCount = toolbox.tools.length;
    final leftTools = toolbox.tools.sublist(0, toolCount ~/ 2);
    final rightTools = toolbox.tools.sublist(toolCount ~/ 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 52), // Temporary centering fix
        for (final tool in leftTools)
          ToolButton(
            tool: tool,
            selected: tool == toolbox.selectedTool,
          ),
        ColorButton(),
        for (final tool in rightTools)
          ToolButton(
            tool: tool,
            selected: tool == toolbox.selectedTool,
          ),
      ],
    );
  }
}
