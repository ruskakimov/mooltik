import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear),
    );
  }
}
