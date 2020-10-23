import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/drawer/pallete_tab/color_picker.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> with SingleTickerProviderStateMixin {
  bool open = false;
  AnimationController _controller;
  Animation _openCloseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..value = 1.0;
    _openCloseAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final reel = context.watch<ReelModel>();

    final bar = ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          BarIconButton(
            icon: FontAwesomeIcons.film,
            onTap: () {},
          ),
          BarIconButton(
            icon: FontAwesomeIcons.solidLemon,
            selected: reel.onion,
            onTap: () {
              reel.onion = !reel.onion;
            },
          ),
          BarIconButton(
            icon: FontAwesomeIcons.fileDownload,
            onTap: () {},
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
                  _toggleDrawer();
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
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _openCloseAnimation,
            child: _buildDrawerBody(),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(64.0 * _openCloseAnimation.value, 0),
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerBody() {
    return RepaintBoundary(
      child: Container(
        width: 64,
        color: Colors.black.withOpacity(0.6),
        child: SizeSelector(),
      ),
    );
  }

  void _toggleDrawer() {
    setState(() {
      open = !open;
    });
    _animateDrawer();
  }

  void _animateDrawer() {
    if (open) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
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
