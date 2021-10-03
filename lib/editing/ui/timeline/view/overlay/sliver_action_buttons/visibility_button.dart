import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/sliver_action_button.dart';
import 'package:provider/provider.dart';

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    Key? key,
    required this.rowIndex,
    required this.colIndex,
  }) : super(key: key);

  final int rowIndex;
  final int colIndex;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return SliverActionButton(
      iconData: timelineView.isLayerVisible(rowIndex)
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      onPressed: () => timelineView.toggleLayerVisibility(rowIndex),
      rowIndex: rowIndex,
      colIndex: colIndex,
    );
  }
}
