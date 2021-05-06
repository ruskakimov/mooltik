import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

class LayerSheet extends StatelessWidget {
  const LayerSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Layers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final reel in reelStack.reels)
                LayerRow(
                  selected: reel == reelStack.activeReel,
                  reel: reel,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LayerRow extends StatelessWidget {
  const LayerRow({
    Key key,
    this.selected,
    this.reel,
  }) : super(key: key);

  final bool selected;
  final FrameReelModel reel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      height: 80,
    );
  }
}
