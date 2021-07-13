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

class LayerRow extends StatefulWidget {
  const LayerRow({
    Key? key,
    required this.reel,
    required this.selected,
    required this.visible,
    required this.canDelete,
  }) : super(key: key);

  final FrameReelModel reel;
  final bool selected;
  final bool visible;
  final bool canDelete;

  @override
  _LayerRowState createState() => _LayerRowState();
}

class _LayerRowState extends State<LayerRow> {
  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      height: 80,
      child: Material(
        color: widget.selected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          onTap: _handleSelect,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CurrentCel(reel: widget.reel),
              SizedBox(width: 4),
              _buildLabel(),
              Spacer(),
              VisibilitySwitch(
                value: widget.visible,
                onChanged: _handleVisibilitySwitch,
              ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        closeOnScroll: true,
        secondaryActions: [
          SlideAction(
            closeOnTap: true,
            child: Container(
              margin: EdgeInsets.only(left: 8),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: LabeledIconButton(
                icon: FontAwesomeIcons.trashAlt,
                label: 'Delete',
                color: Colors.white,
                onTap: widget.canDelete ? _handleDelete : null,
              ),
            ),
          ),
        ],
        child: content,
      ),
    );
  }

  void _handleSelect() {
    final reelStack = context.read<ReelStackModel>();
    reelStack.changeActiveReel(widget.reel);
  }

  void _handleVisibilitySwitch(bool value) {
    final reelStack = context.read<ReelStackModel>();
    reelStack.setLayerVisibility(
      reelStack.reels.indexOf(widget.reel),
      value,
    );
  }

  Future<void> _handleDelete() async {
    final isAnimatedLayer = widget.reel.frameSeq.length > 1;

    final deleteConfirmed = await openDeleteConfirmationDialog(
      context: context,
      name: isAnimatedLayer ? 'animated layer' : 'layer',
      preview: isAnimatedLayer
          ? AnimatedLayerPreview(frames: widget.reel.frameSeq.iterable.toList())
          : FrameWindow(frame: widget.reel.currentFrame),
    );

    if (deleteConfirmed == true) {
      final reelStack = context.read<ReelStackModel>();
      final reelIndex = reelStack.reels.indexOf(widget.reel);
      reelStack.deleteLayer(reelIndex);
    }
  }

  Widget _buildLabel() {
    final count = widget.reel.frameSeq.length;
    final appendix = count > 1 ? 'cels' : 'cel';
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
