import 'package:flutter/material.dart';

class AppCheckbox extends StatefulWidget {
  AppCheckbox({
    Key? key,
    required this.value,
  }) : super(key: key);

  final bool value;

  @override
  _AppCheckboxState createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  @override
  Widget build(BuildContext context) {
    final checkedDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      border: Border.all(width: 2, color: Colors.black),
      shape: BoxShape.circle,
    );

    final uncheckedDecoration = BoxDecoration(
      border: Border.all(
        width: 2,
        color: Theme.of(context).colorScheme.secondary,
      ),
      shape: BoxShape.circle,
    );

    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(8),
      decoration: widget.value ? checkedDecoration : uncheckedDecoration,
      child: widget.value ? Icon(Icons.done, color: Colors.black) : null,
    );
  }
}
