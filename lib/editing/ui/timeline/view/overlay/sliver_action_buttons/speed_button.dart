import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/dialog_done_button.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/sliver_action_button.dart';
import 'package:provider/provider.dart';

class SpeedButton extends StatelessWidget {
  const SpeedButton({
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
      iconData: Icons.speed,
      onPressed: () => _openSpeedDialog(context),
      rowIndex: rowIndex,
      colIndex: colIndex,
    );
  }

  void _openSpeedDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Animation speed'),
            actions: [
              DialogDoneButton(onPressed: () {}),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
