import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_vertical_slider.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/drawer/color_picker_button.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/drawer/color_picker_drawer.dart';
import 'package:mooltik/editor/onion_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

enum RightDrawer {
  strokeSize,
  color,
}

class DrawingActionbar extends StatefulWidget {
  const DrawingActionbar({Key key}) : super(key: key);

  @override
  _DrawingActionbarState createState() => _DrawingActionbarState();
}

class _DrawingActionbarState extends State<DrawingActionbar> {
  RightDrawer rightOpen;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    final bar = Surface(
      child: Row(
        children: <Widget>[
          AppIconButton(
            icon: FontAwesomeIcons.arrowLeft,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          AppIconButton(
            icon: FontAwesomeIcons.lightbulb,
            selected: context.watch<OnionModel>().enabled,
            onTap: () {
              context.read<OnionModel>().toggle();
            },
          ),
          Spacer(),
          AppIconButton(
            icon: FontAwesomeIcons.stepBackward,
            onTap: () {
              context.read<TimelineModel>().stepBackward();
            },
          ),
          AppIconButton(
            icon: FontAwesomeIcons.stepForward,
            onTap: () {
              context.read<TimelineModel>().stepForward();
            },
          ),
          Spacer(),
          for (var i = 0; i < toolbox.tools.length; i++)
            AppIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              onTap: () {
                if (toolbox.tools[i] == toolbox.selectedTool) {
                  setState(() {
                    rightOpen = rightOpen == RightDrawer.strokeSize
                        ? null
                        : RightDrawer.strokeSize;
                  });
                }
                toolbox.selectTool(i);
              },
            ),
          ColorPickerButton(
            onTap: () {
              setState(() {
                rightOpen =
                    rightOpen == RightDrawer.color ? null : RightDrawer.color;
              });
            },
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bar,
        Expanded(
          child: _buildDrawerArea(),
        ),
      ],
    );
  }

  Widget _buildDrawerArea() {
    return Stack(
      alignment: Alignment.center,
      children: [
        StrokeSizeDrawer(
          open: rightOpen == RightDrawer.strokeSize,
        ),
        ColorPickerDrawer(
          open: rightOpen == RightDrawer.color,
        ),
      ],
    );
  }
}

class StrokeSizeDrawer extends StatelessWidget {
  const StrokeSizeDrawer({
    Key key,
    this.open,
  }) : super(key: key);

  final bool open;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final width = toolbox.selectedTool.paint.strokeWidth;

    return AnimatedRightDrawer(
      width: 64,
      open: open,
      child: AppVerticalSlider(
        value: width,
        onChanged: (value) {
          toolbox.changeToolWidth(value.round());
        },
      ),
    );
  }
}
