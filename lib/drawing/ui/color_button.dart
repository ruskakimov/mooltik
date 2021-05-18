import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class ColorButton extends StatefulWidget {
  const ColorButton({
    Key key,
    this.reversePopupSide = false,
  }) : super(key: key);

  final bool reversePopupSide;

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
        arrowSide: widget.reversePopupSide ? ArrowSide.bottom : ArrowSide.top,
        arrowAnchor: widget.reversePopupSide
            ? const Alignment(0, -0.6)
            : const Alignment(0, 0.6),
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
        child: GestureDetector(
          onTap: () {
            if (toolbox.selectedTool is! Eraser) {
              _openPicker();
            }
          },
          child: Container(
            width: 52,
            height: 44,
            color: toolbox.selectedTool.color,
          ),
        ));
  }

  void _openPicker() {
    setState(() => _pickerOpen = true);
  }

  void _closePicker() {
    setState(() => _pickerOpen = false);
  }
}
