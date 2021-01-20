import 'package:flutter/material.dart';

class SizePickerPopup extends StatelessWidget {
  const SizePickerPopup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadiusDirectional.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: SizedBox(
        width: 180,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SizeOptionButton(innerCircleWidth: 6),
            _SizeOptionButton(innerCircleWidth: 12, selected: true),
            _SizeOptionButton(innerCircleWidth: 28),
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
  }) : super(key: key);

  final double innerCircleWidth;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
