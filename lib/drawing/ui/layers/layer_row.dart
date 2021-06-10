import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/open_delete_confirmation_dialog.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';
import 'package:mooltik/drawing/ui/reel/frame_number_box.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/layers/visibility_switch.dart';

class LayerRow extends StatelessWidget {
  const LayerRow({
    Key? key,
    required this.reel,
  }) : super(key: key);

  final FrameReelModel reel;

  @override
  Widget build(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    final selected = reel == reelStack.activeReel;
    final visible = reelStack.isVisible(reelStack.reels.indexOf(reel));

    final content = SizedBox(
      height: 80,
      child: Material(
        color: selected ? Colors.white24 : Colors.transparent,
        child: InkWell(
          onTap: () => reelStack.changeActiveReel(reel),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CurrentCel(reel: reel),
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

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      closeOnScroll: true,
      secondaryActions: [
        SlideAction(
          color: Colors.red,
          closeOnTap: true,
          child: LabeledIconButton(
            icon: FontAwesomeIcons.trashAlt,
            label: 'Delete',
            color: Colors.white,
            onTap:
                reelStack.canDeleteLayer ? () => _handleDelete(context) : null,
          ),
        ),
      ],
      child: content,
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final isAnimatedLayer = reel.frameSeq.length > 1;

    final deleteConfirmed = await openDeleteConfirmationDialog(
      context: context,
      name: isAnimatedLayer ? 'animated layer' : 'layer',
      preview: isAnimatedLayer
          ? AnimatedLayerPreview(frames: reel.frameSeq.iterable.toList())
          : FrameWindow(frame: reel.currentFrame),
    );

    if (deleteConfirmed == true) {
      final reelStack = context.read<ReelStackModel>();
      final reelIndex = reelStack.reels.indexOf(reel);
      reelStack.deleteLayer(reelIndex);
    }
  }

  Widget _buildLabel(BuildContext context) {
    final count = reel.frameSeq.length;
    final appendix = count > 1 ? 'frames' : 'frame';
    return Text('$count $appendix');
  }
}

class CurrentCel extends StatelessWidget {
  const CurrentCel({
    Key? key,
    required this.reel,
  }) : super(key: key);

  final FrameReelModel reel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          FrameWindow(frame: reel.currentFrame),
          Positioned(
            top: 4,
            left: 4,
            child: FrameNumberBox(
              selected: true,
              number: reel.currentIndex + 1,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLayerPreview extends StatefulWidget {
  AnimatedLayerPreview({
    Key? key,
    required this.frames,
  }) : super(key: key);

  final List<Frame> frames;

  @override
  AnimatedLayerPreviewState createState() => AnimatedLayerPreviewState();
}

class AnimatedLayerPreviewState extends State<AnimatedLayerPreview> {
  int _frameIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 150),
      (_) {
        setState(() {
          _frameIndex = (_frameIndex + 1) % widget.frames.length;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FrameWindow(frame: widget.frames[_frameIndex]);
  }
}
