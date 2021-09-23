import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/drawing/ui/layers/animated_layer_preview.dart';
import 'package:mooltik/common/ui/edit_text_dialog.dart';
import 'package:mooltik/common/ui/open_delete_confirmation_dialog.dart';
import 'package:mooltik/common/ui/slide_action_button.dart';
import 'package:mooltik/drawing/ui/painted_glass.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/layers/visibility_switch.dart';

class LayerRow extends StatefulWidget {
  const LayerRow({
    Key? key,
    required this.reel,
    required this.name,
    required this.selected,
    required this.visible,
    required this.canDelete,
    required this.canGroupWithAbove,
    required this.canGroupWithBelow,
    required this.canUngroup,
  }) : super(key: key);

  final FrameReelModel reel;
  final String name;
  final bool selected;
  final bool visible;

  final bool canDelete;
  final bool canGroupWithAbove;
  final bool canGroupWithBelow;
  final bool canUngroup;

  @override
  _LayerRowState createState() => _LayerRowState();
}

class _LayerRowState extends State<LayerRow> {
  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: widget.selected ? Colors.white24 : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        onTap: _handleTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CurrentCel(
              reel: widget.reel,
              showNumber: widget.selected,
            ),
            SizedBox(width: 4),
            Expanded(child: _buildLabel()),
            VisibilitySwitch(
              value: widget.visible,
              onChanged: _handleVisibilitySwitch,
            ),
          ],
        ),
      ),
    );

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      closeOnScroll: true,
      actions: [
        if (widget.canGroupWithAbove)
          SlideActionButton(
            icon: MdiIcons.arrowUpCircle,
            label: 'Sync',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              final reelStack = context.read<ReelStackModel>();
              final layerIndex = reelStack.reels.indexOf(widget.reel);
              reelStack.groupLayerWithAbove(layerIndex);
            },
            rightSide: false,
          ),
        if (widget.canGroupWithBelow)
          SlideActionButton(
            icon: MdiIcons.arrowDownCircle,
            label: 'Sync',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              final reelStack = context.read<ReelStackModel>();
              final layerIndex = reelStack.reels.indexOf(widget.reel);
              reelStack.groupLayerWithBelow(layerIndex);
            },
            rightSide: false,
          ),
        if (widget.canUngroup)
          SlideActionButton(
            icon: MdiIcons.closeCircle,
            label: 'Detach',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              final reelStack = context.read<ReelStackModel>();
              final layerIndex = reelStack.reels.indexOf(widget.reel);
              reelStack.ungroupLayer(layerIndex);
            },
            rightSide: false,
          ),
      ],
      secondaryActions: [
        SlideActionButton(
          icon: MdiIcons.formTextbox,
          label: 'Rename',
          color: Theme.of(context).colorScheme.secondary,
          onTap: _handleRename,
        ),
        SlideActionButton(
          icon: MdiIcons.trashCanOutline,
          label: 'Delete',
          color: Colors.red,
          onTap: widget.canDelete ? _handleDelete : null,
        ),
      ],
      child: content,
    );
  }

  void _handleTap() {
    if (widget.selected) {
      _handleRename();
    } else {
      _handleSelect();
    }
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

  void _handleRename() {
    final reelStack = context.read<ReelStackModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditTextDialog(
          title: 'Layer name',
          initialValue: widget.name,
          onSubmit: (value) {
            reelStack.setLayerName(
              reelStack.reels.indexOf(widget.reel),
              value,
            );
          },
          maxLines: 1,
          maxLength: 30,
        ),
      ),
    );
  }

  Future<void> _handleDelete() async {
    final isAnimatedLayer = widget.reel.frameSeq.length > 1;

    final deleteConfirmed = await openDeleteConfirmationDialog(
      context: context,
      name: isAnimatedLayer ? 'animated layer' : 'layer',
      preview: isAnimatedLayer
          ? AnimatedLayerPreview(frames: widget.reel.frameSeq.iterable.toList())
          : PaintedGlass(image: widget.reel.currentFrame.image),
    );

    if (deleteConfirmed == true) {
      final reelStack = context.read<ReelStackModel>();
      final reelIndex = reelStack.reels.indexOf(widget.reel);
      reelStack.deleteLayer(reelIndex);
    }
  }

  Widget _buildLabel() {
    return Text(
      widget.name,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CurrentCel extends StatelessWidget {
  const CurrentCel({
    Key? key,
    required this.reel,
    required this.showNumber,
  }) : super(key: key);

  final FrameReelModel reel;
  final bool showNumber;

  @override
  Widget build(BuildContext context) {
    final current = reel.currentIndex + 1;
    final length = reel.frameSeq.length;

    return Container(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          PaintedGlass(image: reel.currentFrame.image),
          if (showNumber && length > 1)
            Positioned(
              top: 4,
              left: 4,
              child: _buildBox('$current / $length'),
            ),
        ],
      ),
    );
  }

  Widget _buildBox(String text) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
