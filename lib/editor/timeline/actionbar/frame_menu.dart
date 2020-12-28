import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FrameMenu extends StatelessWidget {
  const FrameMenu({
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16),
          LabeledIconButton(
            icon: FontAwesomeIcons.copy,
            label: 'Duplicate',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: timelineView.duplicateSelected,
          ),
          SizedBox(width: 16),
          LabeledIconButton(
            icon: FontAwesomeIcons.trashAlt,
            label: 'Delete',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: timelineView.deleteSelected,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class LabeledIconButton extends StatelessWidget {
  const LabeledIconButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.color,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightColor: Colors.white,
      radius: 56,
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
