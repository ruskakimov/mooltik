import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/onion_model.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({
    Key key,
    this.width = 320,
    this.onDone,
  }) : super(key: key);

  final double width;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final onion = context.watch<OnionModel>();

    return SizedBox(
      width: width,
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          _MenuTile(
            icon: FontAwesomeIcons.plus,
            title: 'Add empty frame',
            onTap: () {
              context.read<TimelineModel>().addFrameAfterSelected();
              onDone?.call();
            },
          ),
          _MenuTile(
            icon: FontAwesomeIcons.copy,
            title: 'Duplicate this frame',
            onTap: () {
              final timeline = context.read<TimelineModel>();
              timeline.duplicateFrameAt(timeline.selectedFrameIndex);
              timeline.stepForward();
              onDone?.call();
            },
          ),
          Divider(),
          _MenuTile(
            icon: FontAwesomeIcons.lightbulb,
            title: 'Onion skinning',
            trailing: Switch(
              value: onion.enabled,
              onChanged: (_) => onion.toggle(),
            ),
            onTap: () => onion.toggle(),
          ),
          _MenuTile(
            icon: FontAwesomeIcons.expand,
            title: 'Fit canvas to screen',
            onTap: () {
              context.read<EaselModel>().fitToScreen();
              onDone?.call();
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    Key key,
    @required this.icon,
    @required this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Transform.translate(
        offset: Offset(0, 1),
        child: Icon(icon, size: 20),
      ),
      title: Transform.translate(
        offset: Offset(-18, 0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
