import 'package:flutter/material.dart';

class SizePickerPopup extends StatelessWidget {
  const SizePickerPopup({
    Key key,
    @required this.selectedValue,
    @required this.valueOptions,
    this.onSelected,
  }) : super(key: key);

  final double selectedValue;
  final List<double> valueOptions;
  final void Function(double) onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadiusDirectional.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: SizedBox(
        width: 60.0 * valueOptions.length,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final optionValue in valueOptions)
              _SizeOptionButton(
                innerCircleWidth: optionValue,
                selected: optionValue == selectedValue,
                onTap: () {
                  onSelected?.call(optionValue);
                },
              ),
          ],
        ),
      ),
    );
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
