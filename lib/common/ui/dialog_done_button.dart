import 'package:flutter/material.dart';

class DialogDoneButton extends StatelessWidget {
  const DialogDoneButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints.tight(Size.square(kToolbarHeight)),
      icon: Icon(Icons.done),
      tooltip: 'Done',
      onPressed: onPressed,
    );
  }
}
