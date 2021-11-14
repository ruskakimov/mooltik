import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/app_slider.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/brush_tip_picker.dart';

const double _popupWidth = 204;

class ToolButton extends StatefulWidget {
  const ToolButton({
    Key? key,
    required this.tool,
    this.selected = false,
    this.onTap,
    this.iconTransform,
  }) : super(key: key);

  final Tool tool;
  final bool selected;
  final VoidCallback? onTap;
  final Matrix4? iconTransform;

  @override
  _ToolButtonState createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  bool _pickerOpen = false;

  @override
  Widget build(BuildContext context) {
    Widget? popupBody;

    if (widget.tool is Brush) {
      popupBody = BrushPopup(
        brush: widget.tool as Brush,
        onDone: _closePicker,
      );
    }

    final button = AppIconButton(
      icon: widget.tool.icon,
      iconSize: 26,
      iconTransform: widget.iconTransform,
      selected: widget.selected,
      onTap: () {
        final toolbox = context.read<ToolboxModel>();
        if (widget.selected) {
          _openPicker();
        } else {
          toolbox.selectTool(widget.tool);
        }
        widget.onTap?.call();
      },
    );

    return popupBody != null ? _wrapWithPopupEntry(button, popupBody) : button;
  }

  PopupWithArrowEntry _wrapWithPopupEntry(Widget child, Widget popupBody) {
    return PopupWithArrowEntry(
      visible: _pickerOpen && widget.selected,
      arrowSide: ArrowSide.top,
      arrowAnchor: const Alignment(0, 0.8),
      arrowSidePosition: ArrowSidePosition.middle,
      popupBody: popupBody,
      onTapOutside: _closePicker,
      onDragOutside: _closePicker,
      child: child,
    );
  }

  void _openPicker() {
    setState(() => _pickerOpen = true);
  }

  void _closePicker() {
    setState(() => _pickerOpen = false);
  }
}

class BrushPopup extends StatefulWidget {
  const BrushPopup({
    Key? key,
    required this.brush,
    this.onDone,
  }) : super(key: key);

  final Brush brush;
  final VoidCallback? onDone;

  @override
  _BrushPopupState createState() => _BrushPopupState();
}

class _BrushPopupState extends State<BrushPopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _popupWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrushTipPicker(
            selectedIndex: widget.brush.selectedBrushTipIndex,
            brushTips: widget.brush.brushTips,
            minStrokeWidth: widget.brush.minStrokeWidth,
            maxStrokeWidth: widget.brush.maxStrokeWidth,
            onSelected: (int index) {
              widget.brush.selectedBrushTipIndex = index;
              widget.onDone?.call();
            },
          ),
          AppSlider(
            value: widget.brush.strokeWidthPercentage,
            icon: Icons.line_weight_rounded,
            onChanged: (double value) {
              setState(() {
                widget.brush.setStrokeWidthPercentage(value);
              });
            },
          ),
          AppSlider(
            value: widget.brush.opacityPercentage,
            icon: Icons.invert_colors_on_rounded,
            negativeIcon: Icons.invert_colors_off_rounded,
            onChanged: (double value) {
              setState(() {
                widget.brush.setOpacityPercentage(value);
              });
            },
          ),
          AppSlider(
            value: widget.brush.blurPercentage,
            icon: Icons.blur_on_rounded,
            negativeIcon: Icons.blur_off_rounded,
            onChanged: (double value) {
              setState(() {
                widget.brush.setBlurPercentage(value);
              });
            },
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
