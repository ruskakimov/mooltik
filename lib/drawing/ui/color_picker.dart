import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final axis = MediaQuery.of(context).orientation == Orientation.landscape
        ? Axis.horizontal
        : Axis.vertical;

    return Flex(
      direction: axis,
      children: [
        SizedBox(width: 8),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: ColorWheel(
                selectedColor: toolbox.hsvColor,
                onSelected: onSelected,
              ),
            ),
            Positioned(
              top: 16,
              child: _buildColorComparer(toolbox),
            ),
          ],
        ),
        Divider(height: 0),
        SizedBox(width: 8),
        VerticalDivider(width: 0),
        Expanded(
          child: ColorPalette(
            axis: axis,
            colors: toolbox.palette,
          ),
        ),
      ],
    );
  }

  Widget _buildColorComparer(ToolboxModel toolbox) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 44,
      width: 44,
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

class ColorPalette extends StatelessWidget {
  const ColorPalette({
    Key? key,
    required this.axis,
    required this.colors,
  }) : super(key: key);

  final Axis axis;
  final List<HSVColor?> colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        scrollDirection: axis,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        crossAxisCount: 6,
        children: [
          for (var i = 0; i < colors.length; i++)
            _buildCell(context, i, colors[i]),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, int i, HSVColor? color) {
    final color = colors[i];

    return GestureDetector(
      onTap: color == null
          ? () => _fillCell(context, i)
          : () => _takeColorFromCell(context, color),
      onLongPress: () => _emptyCell(context, i),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color?.toColor(),
          border: color == null
              ? Border.all(color: Colors.white10, width: 1)
              : null,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _takeColorFromCell(BuildContext context, HSVColor color) {
    context.read<ToolboxModel>().changeColor(color);
  }

  void _fillCell(BuildContext context, int cellIndex) {
    context.read<ToolboxModel>().fillPaletteCellWithCurrentColor(cellIndex);
  }

  void _emptyCell(BuildContext context, int cellIndex) {
    context.read<ToolboxModel>().emptyPaletteCell(cellIndex);
    HapticFeedback.heavyImpact();
  }
}
