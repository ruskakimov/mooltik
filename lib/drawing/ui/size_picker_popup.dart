import 'package:flutter/material.dart';

class SizePickerPopup extends StatelessWidget {
  const SizePickerPopup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadiusDirectional.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.fiber_manual_record),
          Icon(Icons.fiber_manual_record),
          Icon(Icons.fiber_manual_record),
        ],
      ),
    );
  }
}
