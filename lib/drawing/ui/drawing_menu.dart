import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
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
    return SizedBox(
      width: width,
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          _buildOnionToggle(context),
          _buildFrameReelToggle(context),
          _buildFingerDrawToggle(context),
          _buildFitToScreen(context),
        ],
      ),
    );
  }

  _MenuTile _buildOnionToggle(BuildContext context) {
    final onion = context.watch<OnionModel>();

    return _MenuTile(
      icon: FontAwesomeIcons.lightbulb,
      title: 'Onion skinning',
      trailing: Switch(
        value: onion.enabled,
        onChanged: (_) => onion.toggle(),
      ),
      onTap: () => onion.toggle(),
    );
  }

  _MenuTile _buildFrameReelToggle(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    return _MenuTile(
      icon: FontAwesomeIcons.film,
      title: 'Frame reel',
      trailing: Switch(
        value: reelStack.showFrameReel,
        onChanged: (_) => reelStack.toggleFrameReelVisibility(),
      ),
      onTap: () => reelStack.toggleFrameReelVisibility(),
    );
  }

  _MenuTile _buildFingerDrawToggle(BuildContext context) {
    final easel = context.watch<EaselModel>();

    return _MenuTile(
      icon: FontAwesomeIcons.handPointUp,
      title: 'Draw with finger',
      trailing: Switch(
        value: easel.allowDrawingWithFinger,
        onChanged: (_) => easel.toggleDrawingWithFinger(),
      ),
      onTap: () => easel.toggleDrawingWithFinger(),
    );
  }

  _MenuTile _buildFitToScreen(BuildContext context) {
    return _MenuTile(
      icon: FontAwesomeIcons.expand,
      title: 'Fit canvas to screen',
      onTap: () {
        context.read<EaselModel>().fitToScreen();
        onDone?.call();
      },
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
