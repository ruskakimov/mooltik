import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/picker_option_button.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key key,
    @required this.selectedColor,
    @required this.colorOptions,
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final List<Color> colorOptions;
  final void Function(Color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final color in colorOptions)
            PickerOptionButton(
              innerCircleColor: color,
              selected: color == selectedColor,
            ),
        ],
      ),
    );
  }
}
