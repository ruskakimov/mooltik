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

    return PopupWithArrowEntry(
      visible: _pickerOpen && widget.selected,
      arrowSide: ArrowSide.top,
      arrowAnchor: const Alignment(0, 0.8),
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: BrushPopup(
        brush: toolbox.selectedTool,
        onDone: _closePicker,
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

class BrushPopup extends StatelessWidget {
  const BrushPopup({
    Key key,
    @required this.brush,
    this.onDone,
  }) : super(key: key);

  final Brush brush;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizePicker(
            selectedValue: brush.paint.strokeWidth,
            valueOptions:
                brush.brushTips.map((tip) => tip.strokeWidth).toList(),
            minValue: brush.minStrokeWidth,
            maxValue: brush.maxStrokeWidth,
            onSelected: (double newValue) {
              // toolbox.changeToolStrokeWidth(newValue);
              onDone?.call();
            },
          ),
          AppSlider(
            value: brush.opacity,
            onChanged: (double value) {
              // toolbox.changeToolOpacity(value);
            },
          ),
        ],
      ),
    );
  }
}
