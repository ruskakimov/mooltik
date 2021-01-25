import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
    final showSizePickerOfThisTool = toolbox.sizePickerOpen && selected;

    return PortalEntry(
      visible: showSizePickerOfThisTool,
      portal: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          toolbox.closeSizePicker();
        },
      ),
      child: PortalEntry(
        visible: showSizePickerOfThisTool,
        portal: BrushPopup(
          selectedValue: toolbox.selectedToolStrokeWidth,
          valueOptions: tool.strokeWidthOptions,
          minValue: tool.minStrokeWidth,
          maxValue: tool.maxStrokeWidth,
          onSelected: (double newValue) {
            toolbox.changeToolStrokeWidth(newValue);
            toolbox.closeSizePicker();
          },
        ),
        portalAnchor: Alignment.topCenter,
        child: IgnorePointer(
          ignoring: showSizePickerOfThisTool,
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
        ),
        childAnchor: Alignment.bottomCenter.add(Alignment(0, 0.2)),
      ),
    );
  }
}
