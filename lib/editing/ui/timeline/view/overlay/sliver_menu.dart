import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/open_delete_confirmation_dialog.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/painted_glass.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/animated_scene_preview.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SliverMenu extends StatelessWidget {
  const SliverMenu({
    Key? key,
    required this.showEditScene,
    required this.showDuplicate,
  }) : super(key: key);

  final bool showEditScene;
  final bool showDuplicate;

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
            SizedBox(width: 4),
            SliverDurationLabel(
              durationLabel: timelineView.selectedSliverDurationLabel,
            ),
            SizedBox(width: 8),
            if (showEditScene)
              LabeledIconButton(
                icon: FontAwesomeIcons.film,
                label: 'Edit scene',
                color: Theme.of(context).colorScheme.onPrimary,
                onTap: timelineView.editScene,
              ),
            if (showDuplicate)
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
                  ? () => _handleDelete(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final timelineView = context.read<TimelineViewModel>();

    final selected = timelineView.selectedSpan;
    final selectedSliverId = timelineView.selectedSliverId;

    timelineView.removeSliverSelection();

    // TODO: Handle deleting individual sound clips
    if (selected is SoundClip) {
      timelineView.deleteSoundClips();
      return;
    }

    final deleteConfirmed = await openDeleteConfirmationDialog(
      context: context,
      name: selected is Scene ? 'scene' : 'cel',
      preview: selected is Scene
          ? AnimatedScenePreview(scene: selected)
          : PaintedGlass(image: (selected as Frame).image),
    );

    if (deleteConfirmed == true) {
      timelineView.selectSliver(selectedSliverId);
      timelineView.deleteSelected();
    }
  }
}

class SliverDurationLabel extends StatelessWidget {
  const SliverDurationLabel({
    Key? key,
    required this.durationLabel,
  }) : super(key: key);

  final String? durationLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        durationLabel ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          height: 1.3,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
