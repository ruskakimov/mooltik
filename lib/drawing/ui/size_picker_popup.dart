import 'package:flutter/material.dart';

const double _minInnerCircleWidth = 4;
const double _maxInnerCircleWidth = 34;

const double _triangleWidth = 24;
const double _triangleHeight = 12;

class SizePickerPopup extends StatelessWidget {
  const SizePickerPopup({
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
    final popupWidth = 60.0 * valueOptions.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadiusDirectional.circular(8),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          child: SizedBox(
            width: popupWidth,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
        ),
        Positioned(
          top: -_triangleHeight,
          left: (popupWidth - _triangleWidth) / 2,
          child: _Triangle(),
        ),
      ],
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
      radius: 23,
      onTap: onTap,
      child: Container(
        width: 40,
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

class _Triangle extends StatelessWidget {
  const _Triangle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: _triangleWidth,
        height: _triangleHeight,
        color: Theme.of(context).colorScheme.secondary,
      ),
      clipper: _TriangleClipper(),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  // TODO: Return false
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
