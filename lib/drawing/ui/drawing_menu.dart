import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/onion_model.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({Key key, this.onDone}) : super(key: key);

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final onion = context.watch<OnionModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        ListTile(
          leading: Icon(FontAwesomeIcons.lightbulb, size: 20),
          title: Text('Onion skinning'),
          trailing: Switch(
            value: onion.enabled,
            onChanged: (_) => onion.toggle(),
          ),
          onTap: () => onion.toggle(),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.expand, size: 20),
          title: Text('Fit canvas to screen'),
          onTap: () {
            context.read<EaselModel>().fitToScreen();
            onDone?.call();
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(FontAwesomeIcons.plus, size: 20),
          title: Text('Add empty frame'),
          onTap: () {
            context.read<TimelineModel>().addFrameAfterSelected();
            onDone?.call();
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.copy, size: 20),
          title: Text('Duplicate this frame'),
          onTap: () {
            final timeline = context.read<TimelineModel>();
            timeline.duplicateFrameAt(timeline.selectedFrameIndex);
            timeline.stepForward();
            onDone?.call();
          },
        ),
      ],
    );
  }
}
