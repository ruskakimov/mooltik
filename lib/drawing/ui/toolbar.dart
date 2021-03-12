import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/tool_button.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    this.reversePopupSide = false,
  }) : super(key: key);

  final bool reversePopupSide;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final tool in toolbox.tools)
          ToolButton(
            tool: tool,
            selected: tool == toolbox.selectedTool,
            reversePopupSide: reversePopupSide,
          ),
      ],
    );
  }
}
