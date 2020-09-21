import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:mooltik/editor/drawers/editor_drawer.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(math.pi),
      child: EditorDrawer(
        height: 200,
        quickAccessButtons: [
          DrawerIconButton(
            icon: FontAwesomeIcons.stepBackward,
          ),
          DrawerIconButton(
            icon: FontAwesomeIcons.stepForward,
          ),
        ],
        body: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(math.pi),
          child: _buildDrawerBody(),
        ),
      ),
    );
  }

  Widget _buildDrawerBody() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: _buildTimelineBar(),
        ),
        Expanded(
          child: Timeline(),
        ),
      ],
    );
  }

  Widget _buildTimelineBar() {
    return Builder(builder: (context) {
      final frameNumber = context.watch<TimelineModel>().frameNumber;
      return Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              DrawerIconButton(icon: FontAwesomeIcons.play),
              DrawerIconButton(icon: FontAwesomeIcons.layerGroup),
              Spacer(),
              SizedBox(
                width: 96,
                child: Text(
                  '$frameNumber F',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          DrawerIconButton(icon: FontAwesomeIcons.toolbox),
        ],
      );
    });
  }
}
