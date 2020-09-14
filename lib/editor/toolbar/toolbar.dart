import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<Toolbox>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < toolbox.tools.length; i++)
          IconButton(
            icon: Icon(
              toolbox.tools[i].icon,
              color: toolbox.tools[i] == toolbox.selectedTool
                  ? Colors.amberAccent
                  : Colors.grey,
            ),
            onPressed: () => toolbox.selectTool(i),
          ),
      ],
    );
  }
}
