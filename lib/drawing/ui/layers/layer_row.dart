import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';
import 'package:mooltik/drawing/ui/reel/frame_number_box.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/layers/visibility_switch.dart';

class LayerRow extends StatelessWidget {
  const LayerRow({
    Key? key,
    required this.selected,
    this.visible,
    this.reel,
    this.onTap,
  }) : super(key: key);

  final bool selected;
  final bool? visible;
  final FrameReelModel? reel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Material(
        color: selected ? Colors.white24 : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCell(),
              SizedBox(width: 4),
              _buildLabel(context),
              Spacer(),
              VisibilitySwitch(
                value: visible,
                onChanged: (value) {
                  final reelStack = context.read<ReelStackModel>();
                  reelStack.setLayerVisibility(
                    reelStack.reels.indexOf(reel),
                    value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          FrameWindow(frame: reel!.currentFrame),
          Positioned(
            top: 4,
            left: 4,
            child: FrameNumberBox(
              selected: true,
              number: reel!.currentIndex + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    final count = reel!.frameSeq.length;
    final appendix = count > 1 ? 'frames' : 'frame';
    return Text('$count $appendix');
  }
}
