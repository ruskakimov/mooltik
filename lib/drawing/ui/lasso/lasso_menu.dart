import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';

class LassoMenu extends StatelessWidget {
  const LassoMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    if (!lassoModel.showLassoMenu) {
      return SizedBox.shrink();
    }

    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;

      return Align(
        alignment: isPortrait ? Alignment.topCenter : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadiusDirectional.circular(8),
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            child: Flex(
              direction: isPortrait ? Axis.horizontal : Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8, height: 8),
                LabeledIconButton(
                  icon: MdiIcons.vectorSquare,
                  label: 'Transform',
                  color: Theme.of(context).colorScheme.onPrimary,
                  onTap: lassoModel.transformSelection,
                ),
                LabeledIconButton(
                  icon: MdiIcons.vectorCombine,
                  label: 'Duplicate',
                  color: Theme.of(context).colorScheme.onPrimary,
                  onTap: lassoModel.duplicateSelection,
                ),
                LabeledIconButton(
                  icon: MdiIcons.formatColorFill,
                  iconTransform: Matrix4.identity()
                    ..scale(1.3)
                    ..translate(-2.0),
                  label: 'Fill',
                  color: Theme.of(context).colorScheme.onPrimary,
                  onTap: lassoModel.fillSelection,
                ),
                LabeledIconButton(
                  icon: MdiIcons.eraser,
                  label: 'Erase',
                  color: Theme.of(context).colorScheme.onPrimary,
                  onTap: lassoModel.eraseSelection,
                ),
                const SizedBox(width: 8, height: 8),
              ],
            ),
          ),
        ),
      );
    });
  }
}
