import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class ColorButton extends StatefulWidget {
  const ColorButton({Key? key}) : super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  bool _pickerOpen = false;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final selectedTool = toolbox.selectedTool;
    final selectedColor =
        selectedTool is ToolWithColor ? selectedTool.color : Colors.black;

    return PopupWithArrowEntry(
      visible: _pickerOpen,
      arrowSide: ArrowSide.top,
      arrowAnchor: const Alignment(0, 0.8),
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: ColorPicker(
        selectedColor: selectedColor,
        onSelected: (Color color) {
          toolbox.changeToolColor(color);
          _closePicker();
        },
      ),
      onTapOutside: _closePicker,
      onDragOutside: _closePicker,
      child: SizedBox(
        width: 52,
        height: 44,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            if (selectedTool is ToolWithColor && selectedTool is! Eraser) {
              _openPicker();
            }
          },
          child: Center(
            child: _ColorIndicator(color: selectedColor),
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
