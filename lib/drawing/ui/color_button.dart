import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/open_side_sheet.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return SizedBox(
      width: 52,
      height: 44,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          openSideSheet(
            context: context,
            builder: (context) => ChangeNotifierProvider.value(
              value: toolbox,
              child: ColorPicker(
                selectedColor: toolbox.color,
                onSelected: (HSVColor color) {
                  toolbox.changeColor(color);
                },
              ),
            ),
            side: Side.top,
            maxExtent:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 320
                    : 640,
          );
        },
        child: Center(
          child: _ColorIndicator(color: toolbox.color),
        ),
      ),
    );
  }
}

class _ColorIndicator extends StatelessWidget {
  const _ColorIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 2, color: Colors.white),
        shape: BoxShape.circle,
      ),
    );
  }
}
