import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/drawer/color_picker.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/drawer/menu.dart';
import 'package:mooltik/editor/reel/reel.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

enum LeftDrawer {
  menu,
  reel,
}

class ToolBar extends StatefulWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  bool rightOpen = false;
  LeftDrawer leftOpen;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final reel = context.watch<ReelModel>();

    final bar = ColoredBox(
      color: Colors.blueGrey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          BarIconButton(
            icon: FontAwesomeIcons.bars,
            selected: leftOpen == LeftDrawer.menu,
            onTap: () {
              setState(() {
                leftOpen = leftOpen == LeftDrawer.menu ? null : LeftDrawer.menu;
              });
            },
          ),
          BarIconButton(
            icon: FontAwesomeIcons.film,
            selected: leftOpen == LeftDrawer.reel,
            onTap: () {
              setState(() {
                leftOpen = leftOpen == LeftDrawer.reel ? null : LeftDrawer.reel;
              });
            },
          ),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.play,
            onTap: reel.play,
          ),
          Spacer(),
          for (var i = 0; i < toolbox.tools.length; i++)
            BarIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              onTap: () {
                if (toolbox.tools[i] == toolbox.selectedTool) {
                  _toggleRightDrawer();
                }
                toolbox.selectTool(i);
              },
            ),
          ColorPicker(),
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
      children: [
        AnimatedLeftDrawer(
          width: 112,
          open: leftOpen == LeftDrawer.reel,
          child: Reel(),
        ),
        AnimatedLeftDrawer(
          width: 200,
          open: leftOpen == LeftDrawer.menu,
          child: Menu(),
        ),
        AnimatedRightDrawer(
          width: 64,
          open: rightOpen,
          child: SizeSelector(),
        ),
      ],
    );
  }

  void _toggleRightDrawer() {
    setState(() {
      rightOpen = !rightOpen;
    });
  }
}

class SizeSelector extends StatelessWidget {
  const SizeSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final width = toolbox.selectedTool.paint.strokeWidth;
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              '${width.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: width,
              min: 1.0,
              max: 100.0,
              onChanged: (value) {
                toolbox.changeToolWidth(value.round());
              },
            ),
          ),
        ),
      ],
    );
  }
}
