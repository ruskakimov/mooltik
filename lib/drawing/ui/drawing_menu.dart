import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/menu_tile.dart';
import 'package:mooltik/drawing/data/drawing_page_options_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/onion_model.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({
    Key? key,
    this.width = 320,
    this.onDone,
  }) : super(key: key);

  final double width;
  final VoidCallback? onDone;

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
        ],
      ),
    );
  }

  MenuTile _buildOnionToggle(BuildContext context) {
    final onion = context.watch<OnionModel>();

    return MenuTile(
      icon: FontAwesomeIcons.lightbulb,
      title: 'Onion skinning',
      trailing: Switch(
        value: onion.enabled,
        onChanged: (_) => onion.toggle(),
      ),
      onTap: () => onion.toggle(),
    );
  }

  MenuTile _buildFrameReelToggle(BuildContext context) {
    final options = context.watch<DrawingPageOptionsModel>();

    return MenuTile(
      icon: FontAwesomeIcons.film,
      title: 'Frame reel',
      trailing: Switch(
        value: options.showFrameReel,
        onChanged: (_) => options.toggleFrameReelVisibility(),
      ),
      onTap: () => options.toggleFrameReelVisibility(),
    );
  }

  MenuTile _buildFingerDrawToggle(BuildContext context) {
    final easel = context.watch<DrawingPageOptionsModel>();

    return MenuTile(
      icon: FontAwesomeIcons.handPointUp,
      title: 'Draw with finger',
      trailing: Switch(
        value: easel.allowDrawingWithFinger,
        onChanged: (_) => easel.toggleDrawingWithFinger(),
      ),
      onTap: () => easel.toggleDrawingWithFinger(),
    );
  }
}
