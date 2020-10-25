import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

class ColorPickerDrawer extends StatelessWidget {
  const ColorPickerDrawer({
    Key key,
    this.open,
  }) : super(key: key);

  final bool open;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return AnimatedRightDrawer(
      width: 600,
      open: open,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ColorPicker(
          pickerColor: toolbox.selectedColor,
          onColorChanged: (color) {
            toolbox.selectColor(color);
          },
          showLabel: false,
          pickerAreaHeightPercent: 0.5,
        ),
      ),
    );
  }
}
