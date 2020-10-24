import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/drawer/pallete_tab/color_picker.dart';
import 'package:mooltik/editor/reel/reel.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

const drawerTransitionDuration = Duration(milliseconds: 200);

class ToolBar extends StatefulWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> with TickerProviderStateMixin {
  bool rightOpen = false;
  bool leftOpen = false;

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
            onTap: () {},
          ),
          BarIconButton(
            icon: FontAwesomeIcons.film,
            selected: leftOpen,
            onTap: () {
              _toggleLeftDrawer();
            },
          ),
          BarIconButton(
            icon: FontAwesomeIcons.solidLemon,
            selected: reel.onion,
            onTap: () {
              reel.onion = !reel.onion;
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
        AnimatedPositioned(
          duration: drawerTransitionDuration,
          left: leftOpen ? 0 : -112.0,
          top: 0,
          bottom: 0,
          width: 112,
          child: Container(
            color: Colors.blueGrey[800],
            child: Reel(),
          ),
        ),
        AnimatedPositioned(
          duration: drawerTransitionDuration,
          right: rightOpen ? 0 : -64.0,
          top: 0,
          bottom: 0,
          width: 64,
          child: Container(
            color: Colors.blueGrey[800],
            child: SizeSelector(),
          ),
        ),
      ],
    );
  }

  void _toggleRightDrawer() {
    setState(() {
      rightOpen = !rightOpen;
    });
  }

  void _toggleLeftDrawer() {
    setState(() {
      leftOpen = !leftOpen;
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
