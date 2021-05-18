import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/picker_option_button.dart';

const _columns = 3;
const _buttonWidth = 44.0;
const _gap = 12.0;

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key key,
    @required this.selectedColor,
    this.colorOptions = const [
      Colors.black,
      Colors.redAccent,
      Colors.yellow,
      Colors.teal,
      Colors.blue,
      Colors.deepPurple,
    ],
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final List<Color> colorOptions;
  final void Function(Color) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonWidth * _columns + _gap * (_columns + 1),
      child: GridView.count(
        crossAxisCount: _columns,
        shrinkWrap: true,
        mainAxisSpacing: _gap,
        crossAxisSpacing: _gap,
        padding: const EdgeInsets.all(_gap),
        children: [
          for (final color in colorOptions)
            PickerOptionButton(
              innerCircleColor: color,
              selected: color.value == selectedColor.value,
              onTap: () {
                onSelected?.call(color);
              },
            ),
        ],
      ),
    );
  }
}
