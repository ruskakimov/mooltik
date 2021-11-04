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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Stack(
          children: [
            ColorWheel(
              selectedColor: toolbox.hsvColor,
              onSelected: onSelected,
            ),
            _buildColorComparer(toolbox),
          ],
        ),
      ],
    );
  }

  Widget _buildColorComparer(ToolboxModel toolbox) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: selectedColor,
        gradient: LinearGradient(
          colors: [
            selectedColor,
            selectedColor,
            toolbox.color,
            toolbox.color,
          ],
          stops: [0, 0.5, 0.5, 1],
        ),
        shape: BoxShape.circle,
        // borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
