import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/tool_button.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 52), // Bucket placeholder
        ToolButton(
          tool: toolbox.paintBrush,
          selected: toolbox.selectedTool is PaintBrush,
        ),
        ColorButton(),
        ToolButton(
          tool: toolbox.eraser,
          selected: toolbox.selectedTool is Eraser,
        ),
        ToolButton(
          tool: toolbox.lasso,
          selected: toolbox.selectedTool is Lasso,
          onTap: () {
            context.read<LassoModel>().endTransformMode();
          },
        ),
      ],
    );
  }
}
