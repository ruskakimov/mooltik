import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/app_slider.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/ui/color_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/size_picker.dart';

class ToolButton extends StatefulWidget {
  const ToolButton({
    Key key,
    @required this.tool,
    this.selected = false,
  }) : super(key: key);

  final Tool tool;
  final bool selected;

  @override
  _ToolButtonState createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  bool _pickerOpen = false;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return PopupWithArrowEntry(
      visible: _pickerOpen && widget.selected,
      arrowSide: ArrowSide.top,
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: SizedBox(
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.tool.strokeWidthOptions.isNotEmpty)
              SizePicker(
                selectedValue: toolbox.selectedToolStrokeWidth,
                valueOptions: widget.tool.strokeWidthOptions,
                minValue: widget.tool.minStrokeWidth,
                maxValue: widget.tool.maxStrokeWidth,
                onSelected: (double newValue) {
                  toolbox.changeToolStrokeWidth(newValue);
                  _closePicker();
                },
              ),
            ColorPicker(
              selectedColor: Colors.black,
              colorOptions: [
                // Colors.black,
                // Colors.redAccent,
                Colors.yellow,
                // Colors.teal,
                Colors.blue,
                Colors.purpleAccent,
              ],
            ),
            AppSlider(
              value: toolbox.selectedToolOpacity,
              onChanged: (double value) {
                toolbox.changeToolOpacity(value);
              },
            ),
          ],
        ),
      ),
      onTapOutside: _closePicker,
      onDragOutside: _closePicker,
      child: AppIconButton(
        icon: widget.tool.icon,
        selected: widget.selected,
        selectedColor: Colors.black,
        onTap: () {
          if (widget.selected) {
            _openPicker();
          } else {
            toolbox.selectTool(widget.tool);
          }
        },
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
