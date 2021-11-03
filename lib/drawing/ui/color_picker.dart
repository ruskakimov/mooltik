import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/color_wheel.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key? key,
    required this.selectedColor,
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final void Function(Color)? onSelected;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final selectedTool = toolbox.selectedTool;
    final selectedColor =
        selectedTool is ToolWithColor ? selectedTool.color : Colors.black;

    return Column(
      children: [
        ColorWheel(
          selectedColor: selectedColor,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
