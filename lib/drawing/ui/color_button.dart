import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/open_side_sheet.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final selectedTool = toolbox.selectedTool;
    final selectedColor =
        selectedTool is ToolWithColor ? selectedTool.color : Colors.black;

    return SizedBox(
      width: 52,
      height: 44,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (selectedTool is ToolWithColor && selectedTool is! Eraser) {
            openSideSheet(
              context: context,
              builder: (context) => ColorPicker(
                selectedColor: selectedColor,
                onSelected: (Color color) {
                  toolbox.changeToolColor(color);
                },
              ),
              side: MediaQuery.of(context).orientation == Orientation.landscape
                  ? Side.top
                  : Side.right,
              transitionDuration: const Duration(milliseconds: 100),
            );
          }
        },
        child: Center(
          child: _ColorIndicator(color: selectedColor),
        ),
      ),
    );
  }
}

class _ColorIndicator extends StatelessWidget {
  const _ColorIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 2, color: Colors.white),
        shape: BoxShape.circle,
      ),
    );
  }
}
