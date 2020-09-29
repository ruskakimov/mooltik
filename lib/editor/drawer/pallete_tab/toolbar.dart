import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
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

    final bar = ColoredBox(
      color: Colors.blueGrey[700],
      child: Column(
        children: <Widget>[
          for (var i = 0; i < toolbox.tools.length; i++)
            BarIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              label: toolbox.tools[i].paint.strokeWidth.toStringAsFixed(0),
              onTap: () {
                if (toolbox.tools[i] == toolbox.selectedTool) {
                  _toggleDrawer();
                }
                toolbox.selectTool(i);
              },
            ),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _openCloseAnimation,
          child: _buildDrawerBody(),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(64.0 * _openCloseAnimation.value, 0),
              child: child,
            );
          },
        ),
        bar,
      ],
    );
  }

  Widget _buildDrawerBody() {
    return RepaintBoundary(
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 12)],
        ),
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
