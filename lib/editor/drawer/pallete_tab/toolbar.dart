import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

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
    );
    _openCloseAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final frame = context.watch<FrameModel>();
    final playing = context.watch<TimelineModel>().playing;

    final bar = ColoredBox(
      color: Colors.blueGrey[700],
      child: Column(
        children: <Widget>[
          for (var i = 0; i < toolbox.tools.length; i++)
            BarIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              label: toolbox.tools[i].paint.strokeWidth.toStringAsFixed(0),
              onTap: () => toolbox.selectTool(i),
            ),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.undo,
            onTap: frame.undoAvailable && !playing ? frame.undo : null,
          ),
          BarIconButton(
            icon: FontAwesomeIcons.redo,
            onTap: frame.redoAvailable && !playing ? frame.redo : null,
          ),
        ],
      ),
    );

    return Stack(
      alignment: Alignment.topRight,
      children: [
        AnimatedBuilder(
          animation: _openCloseAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-48 + 64.0 * _openCloseAnimation.value, 0),
              child: _buildDrawerBody(),
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
                toolbox.changeStrokeWidth(value.round());
              },
            ),
          ),
        ),
      ],
    );
  }
}
