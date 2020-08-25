import 'package:flutter/material.dart';

enum Tool {
  pencil,
  eraser,
}

class ToolBar extends StatelessWidget {
  const ToolBar({
    Key key,
    @required this.selectedTool,
  }) : super(key: key);

  final Tool selectedTool;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
        ),
        IconButton(
          icon: Icon(Icons.clear),
        ),
      ],
    );
  }
}
