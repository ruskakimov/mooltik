import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/brush_popup.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({
    Key key,
    @required this.tool,
    this.selected = false,
  }) : super(key: key);

  final Tool tool;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return PopupEntry(
      visible: toolbox.sizePickerOpen && selected,
      popup: BrushPopup(
        selectedValue: toolbox.selectedToolStrokeWidth,
        valueOptions: tool.strokeWidthOptions,
        minValue: tool.minStrokeWidth,
        maxValue: tool.maxStrokeWidth,
        onSelected: (double newValue) {
          toolbox.changeToolStrokeWidth(newValue);
          toolbox.closeSizePicker();
        },
      ),
      onTapOutside: () {
        toolbox.closeSizePicker();
      },
      child: AppIconButton(
        icon: tool.icon,
        selected: selected,
        onTap: () {
          if (selected) {
            toolbox.openSizePicker();
          } else {
            toolbox.selectTool(tool);
          }
        },
      ),
    );
  }
}
