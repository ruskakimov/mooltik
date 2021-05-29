import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/lasso_model.dart';
import 'package:mooltik/drawing/ui/menu_button.dart';
import 'package:mooltik/drawing/ui/toolbar.dart';
import 'package:provider/provider.dart';

class DrawingActionbar extends StatelessWidget {
  const DrawingActionbar({
    Key key,
    @required this.twoRow,
    @required this.height,
  }) : super(key: key);

  final bool twoRow;
  final double height;

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final lassoModel = context.watch<LassoModel>();

    return Material(
      elevation: 10,
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                AppIconButton(
                  icon: FontAwesomeIcons.arrowLeft,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                MenuButton(),
                Spacer(),
                if (!twoRow) Toolbar(),
                Spacer(),
                AppIconButton(
                  icon: FontAwesomeIcons.undo,
                  onTap: easel.undoAvailable && !lassoModel.isTransformMode
                      ? easel.undo
                      : null,
                ),
                AppIconButton(
                  icon: FontAwesomeIcons.redo,
                  onTap: easel.redoAvailable && !lassoModel.isTransformMode
                      ? easel.redo
                      : null,
                ),
              ],
            ),
            if (twoRow) Divider(height: 0),
            if (twoRow) Toolbar(),
          ],
        ),
      ),
    );
  }
}
