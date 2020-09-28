import 'package:flutter/material.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

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
}
