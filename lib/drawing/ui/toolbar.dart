import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/bucket.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/tool_button.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToolButton(
          tool: toolbox.bucket,
          iconTransform:
              Matrix4Transform().scale(1.15, origin: Offset(52 / 2, 0)).m,
          selected: toolbox.selectedTool is Bucket,
        ),
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
