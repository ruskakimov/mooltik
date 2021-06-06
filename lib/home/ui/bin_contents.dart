import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:provider/provider.dart';

import '../data/gallery_model.dart';

class BinContents extends StatelessWidget {
  const BinContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = context.watch<GalleryModel>();
    final binnedProjects = gallery.binnedProjects;

    return ClipRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Bin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: binnedProjects.isEmpty
                ? _EmptyState()
                : _BinItemList(binnedProjects: binnedProjects),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MdiIcons.bee),
          SizedBox(height: 12),
          Text('Nothing here...'),
          SizedBox(height: 52),
        ],
      ),
    );
  }
}

class _BinItemList extends StatelessWidget {
  const _BinItemList({
    Key? key,
    required this.binnedProjects,
  }) : super(key: key);

  final List<Project> binnedProjects;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      children: [
        for (final project in binnedProjects)
          _BinItem(
            key: Key('${project.creationEpoch}'),
            project: project,
          )
      ],
    );
  }
}

class _BinItem extends StatelessWidget {
  const _BinItem({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      closeOnScroll: true,
      secondaryActions: [
        SlideAction(
          color: Colors.red,
          closeOnTap: true,
          child: LabeledIconButton(
            icon: FontAwesomeIcons.burn,
            label: 'Destroy',
            color: Colors.white,
            onTap: () {
              context.read<GalleryModel>().deleteProject(project);
            },
          ),
        ),
      ],
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            _buildThumbnail(),
            _buildLabel(context),
            // Text('${project.allFrames.length}'), <- Project data isn't loaded :/
            Spacer(),
            LabeledIconButton(
              icon: FontAwesomeIcons.reply,
              label: 'Restore',
              color: Theme.of(context).colorScheme.onSurface,
              onTap: () {
                context.read<GalleryModel>().restoreProject(project);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.file(project.thumbnail),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('12 images'),
        SizedBox(height: 4),
        Text(
          '23 MB',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
