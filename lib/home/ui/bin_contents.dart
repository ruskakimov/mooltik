import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/sheet_title.dart';
import 'package:mooltik/common/ui/slide_action_button.dart';
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
          SheetTitle('Bin'),
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

class _BinItemList extends StatefulWidget {
  const _BinItemList({
    Key? key,
    required this.binnedProjects,
  }) : super(key: key);

  final List<Project> binnedProjects;

  @override
  __BinItemListState createState() => __BinItemListState();
}

class __BinItemListState extends State<_BinItemList> {
  @override
  void initState() {
    super.initState();
    widget.binnedProjects.forEach((project) => project.readMetadata());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        right: 8,
        left: 8,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      children: [
        for (final project in widget.binnedProjects)
          ChangeNotifierProvider.value(
            value: project,
            child: _BinItem(
              key: Key('${project.creationEpoch}'),
            ),
          )
      ],
    );
  }
}

class _BinItem extends StatelessWidget {
  const _BinItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final project = context.watch<Project>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        closeOnScroll: true,
        secondaryActions: [
          SlideActionButton(
            icon: MdiIcons.fireAlert,
            label: 'Destroy',
            color: Colors.red,
            onTap: () {
              context.read<GalleryModel>().deleteProject(project);
            },
          ),
        ],
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              _buildThumbnail(project),
              SizedBox(width: 8),
              _buildLabel(context, project),
              Spacer(),
              LabeledIconButton(
                icon: MdiIcons.restore,
                iconSize: 20,
                label: 'Restore',
                color: Theme.of(context).colorScheme.onSurface,
                onTap: () {
                  context.read<GalleryModel>().restoreProject(project);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(Project project) {
    return Container(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.file(project.thumbnail),
    );
  }

  Widget _buildLabel(BuildContext context, Project project) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.fileCountLabel),
        SizedBox(height: 4),
        Text(
          project.projectSizeLabel,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
