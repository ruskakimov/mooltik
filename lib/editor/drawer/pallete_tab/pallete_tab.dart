import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/pallete_tab/color_picker.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import 'package:mooltik/editor/drawer/pallete_tab/toolbar.dart';

class PalleteTab extends StatefulWidget {
  const PalleteTab({Key key}) : super(key: key);

  @override
  _PalleteTabState createState() => _PalleteTabState();
}

class _PalleteTabState extends State<PalleteTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWidthSelector(),
        _buildColorSelector(),
      ],
    );
  }

  Widget _buildWidthSelector() {
    final toolbox = context.watch<ToolboxModel>();
    final width = toolbox.selectedTool.paint.strokeWidth;
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              '${width.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: width,
              min: 1.0,
              max: 100.0,
              onChanged: (value) {
                toolbox.changeStrokeWidth(value.round());
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    final toolbox = context.watch<ToolboxModel>();
    final color = toolbox.selectedTool.paint.color;
    return Column(
      children: [
        ColorPicker(color: color),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: color.opacity,
              onChanged: toolbox.changeOpacity,
            ),
          ),
        ),
      ],
    );
  }
}
