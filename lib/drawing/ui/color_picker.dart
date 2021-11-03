import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/color_wheel.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key? key,
    required this.selectedColor,
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final void Function(HSVColor)? onSelected;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return Column(
      children: [
        ColorWheel(
          selectedColor: toolbox.hsvColor,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
