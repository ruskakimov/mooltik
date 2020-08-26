import 'package:flutter/material.dart';

import 'tools.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    Key key,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final Tool value;
  final ValueChanged<Tool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            color: value == Tool.pencil ? Colors.black : Colors.grey,
          ),
          onPressed: () => onChanged(Tool.pencil),
        ),
        IconButton(
          icon: Icon(
            Icons.brush,
            color: value == Tool.eraser ? Colors.black : Colors.grey,
          ),
          onPressed: () => onChanged(Tool.eraser),
        ),
      ],
    );
  }
}
