import 'dart:ui';

import 'package:flutter/material.dart';
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
