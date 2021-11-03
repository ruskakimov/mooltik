import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/color_wheel.dart';

const _buttonWidth = 36.0;

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

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    Key? key,
    required this.color,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  final Color color;
  final bool selected;
  final void Function(Color)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        onSelected?.call(color);
      },
      child: SizedBox(
        width: _buttonWidth,
        height: _buttonWidth,
        child: selected
            ? _addSelectionRing(ColoredBox(color: color))
            : ColoredBox(color: color),
      ),
    );
  }

  Widget _addSelectionRing(Widget child) => Stack(
        fit: StackFit.expand,
        children: [
          child,
          Container(
            margin: const EdgeInsets.all(2),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 8,
                color: Colors.black38,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
}
