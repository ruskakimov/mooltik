import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';

class LassoMenu extends StatelessWidget {
  const LassoMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadiusDirectional.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledIconButton(
            icon: MdiIcons.vectorSquare,
            label: 'Transform',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () {},
          ),
          LabeledIconButton(
            icon: MdiIcons.vectorCombine,
            label: 'Duplicate',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () {},
          ),
          LabeledIconButton(
            icon: MdiIcons.formatColorFill,
            iconTransform: Matrix4.identity()
              ..scale(1.3)
              ..translate(-2.0),
            label: 'Fill',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () {},
          ),
          LabeledIconButton(
            icon: MdiIcons.eraser,
            label: 'Erase',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
