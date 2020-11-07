import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_vertical_slider.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/drawer/color_picker_button.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/drawer/color_picker_drawer.dart';
import 'package:mooltik/editor/drawer/menu_drawer.dart';
import 'package:mooltik/editor/reel/reel_drawer.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

enum LeftDrawer {
  menu,
  reel,
}

enum RightDrawer {
  strokeSize,
  color,
}

class ToolBar extends StatefulWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  LeftDrawer leftOpen;
  RightDrawer rightOpen;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final reel = context.watch<ReelModel>();

    final bar = Surface(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AppIconButton(
            icon: FontAwesomeIcons.bars,
            selected: leftOpen == LeftDrawer.menu,
            onTap: () {
              setState(() {
                leftOpen = leftOpen == LeftDrawer.menu ? null : LeftDrawer.menu;
              });
            },
          ),
          AppIconButton(
            icon: FontAwesomeIcons.film,
            selected: leftOpen == LeftDrawer.reel,
            onTap: () {
              setState(() {
                leftOpen = leftOpen == LeftDrawer.reel ? null : LeftDrawer.reel;
              });
            },
          ),
          Spacer(),
          AppIconButton(
            icon: FontAwesomeIcons.play,
            onTap: reel.play,
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
        ReelDrawer(
          open: leftOpen == LeftDrawer.reel,
        ),
        MenuDrawer(
          open: leftOpen == LeftDrawer.menu,
        ),
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
