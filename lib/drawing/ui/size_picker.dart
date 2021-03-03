import 'package:flutter/material.dart';

const double _padding = 12;
const double _circleSize = 44;

const double _minInnerCircleWidth = 4;
const double _maxInnerCircleWidth = 34;

class SizePicker extends StatelessWidget {
  const SizePicker({
    Key key,
    @required this.selectedValue,
    @required this.valueOptions,
    @required this.minValue,
    @required this.maxValue,
    this.onSelected,
  }) : super(key: key);

  final double selectedValue;
  final List<double> valueOptions;
  final double minValue;
  final double maxValue;
  final void Function(double) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final optionValue in valueOptions)
            _SizeOptionButton(
              innerCircleWidth: _calculateInnerCircleWidth(optionValue),
              selected: optionValue == selectedValue,
              onTap: () {
                onSelected?.call(optionValue);
              },
            ),
        ],
      ),
    );
  }

  /// [minValue] -> [_minInnerCircleWidth]
  /// [maxValue] -> [_maxInnerCircleWidth]
  double _calculateInnerCircleWidth(double value) {
    final radiusRange = _maxInnerCircleWidth - _minInnerCircleWidth;
    final valueRange = maxValue - minValue;
    final sliderValue = (value - minValue) / valueRange;
    return _minInnerCircleWidth + sliderValue * radiusRange;
  }
}

class _SizeOptionButton extends StatelessWidget {
  const _SizeOptionButton({
    Key key,
    this.innerCircleWidth = 10,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final double innerCircleWidth;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: _circleSize / 2 + 3,
      onTap: onTap,
      child: Container(
        width: _circleSize,
        height: _circleSize,
        decoration: BoxDecoration(
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: innerCircleWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
