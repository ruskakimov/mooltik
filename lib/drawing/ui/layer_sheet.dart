import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(),
            Spacer(),
            _buildAddLayerButton(reelStack),
          ],
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

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Layers',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddLayerButton(ReelStackModel reelStack) {
    return AppIconButton(
      icon: FontAwesomeIcons.plus,
      onTap: () {},
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
