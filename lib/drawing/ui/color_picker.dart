import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/color_wheel.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key? key,
    required this.initialColor,
    this.onSelected,
  }) : super(key: key);

  final HSVColor initialColor;
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
              child: GestureDetector(
                onTap: () => toolbox.changeColor(initialColor),
                child: _buildColorComparer(toolbox),
              ),
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
        gradient: LinearGradient(
          colors: [
            initialColor.toColor(),
            initialColor.toColor(),
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

class ColorPalette extends StatefulWidget {
  const ColorPalette({
    Key? key,
    required this.axis,
    required this.colors,
  }) : super(key: key);

  final Axis axis;
  final List<HSVColor?> colors;

  @override
  State<ColorPalette> createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  late final List<HSVColor?> _prevColors;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _prevColors = List.filled(widget.colors.length, null);

    final toolbox = context.read<ToolboxModel>();
    _controller = ScrollController(
      initialScrollOffset: toolbox.paletteScollOffset,
    )..addListener(() => toolbox.paletteScollOffset = _controller.offset);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        controller: _controller,
        scrollDirection: widget.axis,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        crossAxisCount: 6,
        children: [
          for (var i = 0; i < widget.colors.length; i++)
            _buildCell(context, i, widget.colors[i]),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, int i, HSVColor? color) {
    final color = widget.colors[i];

    return GestureDetector(
      onTap: color == null
          ? () => _fillCell(context, i)
          : () => _takeColorFromCell(context, color),
      onLongPress: color == null
          ? () => _refillCell(context, i)
          : () => _emptyCell(context, i),
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

  void _fillCell(BuildContext context, int cellIndex) {
    final toolbox = context.read<ToolboxModel>();
    toolbox.setPaletteCell(cellIndex, toolbox.hsvColor);
  }

  void _takeColorFromCell(BuildContext context, HSVColor color) {
    final toolbox = context.read<ToolboxModel>();
    toolbox.changeColor(color);
  }

  void _refillCell(BuildContext context, int cellIndex) {
    final toolbox = context.read<ToolboxModel>();
    toolbox.setPaletteCell(cellIndex, _prevColors[cellIndex]);
    HapticFeedback.lightImpact();
  }

  void _emptyCell(BuildContext context, int cellIndex) {
    final toolbox = context.read<ToolboxModel>();
    _prevColors[cellIndex] = toolbox.palette[cellIndex];
    toolbox.setPaletteCell(cellIndex, null);
    HapticFeedback.heavyImpact();
  }
}
