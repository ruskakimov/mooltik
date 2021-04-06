import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SliverMenu extends StatelessWidget {
  const SliverMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      elevation: 10,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledIconButton(
              icon: FontAwesomeIcons.copy,
              label: 'Duplicate',
              color: Theme.of(context).colorScheme.onPrimary,
              onTap: timelineView.duplicateSelected,
            ),
            LabeledIconButton(
              icon: FontAwesomeIcons.trashAlt,
              label: 'Delete',
              color: Theme.of(context).colorScheme.onPrimary,
              onTap: timelineView.canDeleteSelected
                  ? timelineView.deleteSelected
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
