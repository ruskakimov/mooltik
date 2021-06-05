import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
import 'package:mooltik/drawing/ui/brush_tip_button.dart';

class BrushTipPicker extends StatelessWidget {
  const BrushTipPicker({
    Key? key,
    required this.selectedIndex,
    required this.brushTips,
    required this.minStrokeWidth,
    required this.maxStrokeWidth,
    this.onSelected,
  }) : super(key: key);

  final int selectedIndex;
  final List<BrushTip> brushTips;

  final double minStrokeWidth;
  final double maxStrokeWidth;

  final void Function(int)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < brushTips.length; i++)
            BrushTipButton(
              canvasSize: Size.square(maxStrokeWidth * 2),
              brushTip: brushTips[i],
              selected: i == selectedIndex,
              onTap: () {
                onSelected?.call(i);
              },
            ),
        ],
      ),
    );
  }
}
