import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:mooltik/drawing/ui/picker_option_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class ColorButton extends StatefulWidget {
  const ColorButton({Key key}) : super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  bool _pickerOpen = false;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return PopupWithArrowEntry(
      visible: _pickerOpen,
      arrowSide: ArrowSide.top,
      arrowAnchor: const Alignment(0, 0.8),
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: SizedBox(
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              selectedColor: toolbox.selectedTool.color,
              colorOptions: const [
                Colors.black,
                Colors.redAccent,
                Colors.yellow,
                Colors.teal,
                Colors.blue,
                Colors.deepPurple,
              ],
              onSelected: (Color color) {
                toolbox.changeToolColor(color);
                _closePicker();
              },
            ),
          ],
        ),
      ),
      onTapOutside: _closePicker,
      onDragOutside: _closePicker,
      child: SizedBox(
        width: 52,
        height: 44,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            if (toolbox.selectedTool is! Eraser) {
              _openPicker();
            }
          },
          child: Center(
            child: PickerOptionButton(
              selected: true,
              size: 32,
              innerCircleColor: toolbox.selectedTool.color,
            ),
          ),
        ),
      ),
    );
  }

  void _openPicker() {
    setState(() => _pickerOpen = true);
  }

  void _closePicker() {
    setState(() => _pickerOpen = false);
  }
}
