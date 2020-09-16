import 'package:flutter/material.dart';
import 'package:mooltik/editor/toolbox/toolbox.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as fcp;

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showColorPicker(context),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final toolbox = context.read<Toolbox>();
    showDialog(
      context: context,
      child: AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: fcp.ColorPicker(
            pickerColor: toolbox.selectedTool.paint.color,
            onColorChanged: (color) {
              toolbox.changeColor(color);
            },
            showLabel: false,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
      ),
    );
  }
}
