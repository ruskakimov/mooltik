import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/picker_option_button.dart';

class SizePicker extends StatelessWidget {
  const SizePicker({
    Key key,
    @required this.selectedIndex,
    @required this.valueOptions,
    @required this.minValue,
    @required this.maxValue,
    this.onSelected,
  }) : super(key: key);

  final int selectedIndex;
  final List<double> valueOptions;
  final double minValue;
  final double maxValue;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < valueOptions.length; i++)
            PickerOptionButton(
              innerCircleWidth: _calculateInnerCircleWidth(valueOptions[i]),
              selected: i == selectedIndex,
              onTap: () {
                onSelected?.call(i);
              },
            ),
        ],
      ),
    );
  }

  /// [minValue] -> [_minInnerCircleWidth]
  /// [maxValue] -> [_maxInnerCircleWidth]
  double _calculateInnerCircleWidth(double value) {
    final min = PickerOptionButton.minInnerCircleWidth;
    final max = PickerOptionButton.maxInnerCircleWidth;

    final valueRange = maxValue - minValue;
    final sliderValue = (value - minValue) / valueRange;
    return min + sliderValue * (max - min);
  }
}
