import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/ui/menu_button.dart';
import 'package:provider/provider.dart';

class DrawingActionbar extends StatelessWidget {
  const DrawingActionbar({Key key, this.middle}) : super(key: key);

  final Widget middle;

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final frameReel = context.watch<FrameReelModel>();

    return Material(
      elevation: 10,
      child: Row(
        children: <Widget>[
          AppIconButton(
            icon: FontAwesomeIcons.arrowLeft,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          MenuButton(),
          AppIconButton(
            icon: FontAwesomeIcons.film,
            selected: frameReel.open,
            onTap: frameReel.toggleVisibility,
          ),
          Spacer(),
          if (middle != null) middle,
          Spacer(),
          AppIconButton(
            icon: FontAwesomeIcons.layerGroup,
          ),
          AppIconButton(
            icon: FontAwesomeIcons.undo,
            onTap: easel.undoAvailable ? easel.undo : null,
          ),
          AppIconButton(
            icon: FontAwesomeIcons.redo,
            onTap: easel.redoAvailable ? easel.redo : null,
          ),
        ],
      ),
    );
  }
}
