import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

class ColorPickerDrawer extends StatelessWidget {
  const ColorPickerDrawer({
    Key key,
    this.open,
  }) : super(key: key);

  final bool open;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return AnimatedRightDrawer(
      width: 400,
      open: open,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ColorPicker(
          pickerColor: toolbox.selectedColor,
          onColorChanged: (color) {
            toolbox.selectColor(color);
          },
          showLabel: false,
        ),
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    @required this.pickerColor,
    @required this.onColorChanged,
    this.paletteType: PaletteType.hsv,
    this.enableAlpha: true,
    this.showLabel: true,
    this.labelTextStyle,
    this.displayThumbColor: false,
    this.pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(4)),
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final bool showLabel;
  final TextStyle labelTextStyle;
  final bool displayThumbColor;
  final BorderRadius pickerAreaBorderRadius;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    super.initState();
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      (HSVColor color) {
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
      },
      displayThumbColor: widget.displayThumbColor,
    );
  }

  Widget colorPickerArea() {
    return ClipRRect(
      borderRadius: widget.pickerAreaBorderRadius,
      child: ColorPickerArea(
        currentHsvColor,
        (HSVColor color) {
          setState(() => currentHsvColor = color);
          widget.onColorChanged(currentHsvColor.toColor());
        },
        widget.paletteType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: colorPickerArea(),
        ),
        SizedBox(
          height: 48,
          child: colorPickerSlider(TrackType.hue),
        ),
        SizedBox(
          height: 48,
          child: colorPickerSlider(TrackType.alpha),
        ),
      ],
    );
  }
}
