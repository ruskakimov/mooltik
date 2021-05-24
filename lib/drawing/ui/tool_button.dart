import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/app_slider.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
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
    final showSizePicker = widget.tool is Brush
        ? (widget.tool as Brush).strokeWidthOptions.isNotEmpty
        : false;

    return PopupWithArrowEntry(
      visible: _pickerOpen && widget.selected,
      arrowSide: ArrowSide.top,
      arrowAnchor: const Alignment(0, 0.8),
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: SizedBox(
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSizePicker)
              SizePicker(
                selectedValue: (toolbox.selectedTool as Brush).strokeWidth,
                valueOptions: (widget.tool as Brush).strokeWidthOptions,
                minValue: (widget.tool as Brush).minStrokeWidth,
                maxValue: (widget.tool as Brush).maxStrokeWidth,
                onSelected: (double newValue) {
                  toolbox.changeToolStrokeWidth(newValue);
                  _closePicker();
                },
              ),
            if (toolbox.selectedTool is Brush)
              AppSlider(
                value: (toolbox.selectedTool as Brush).opacity,
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
