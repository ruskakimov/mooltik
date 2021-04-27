import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:provider/provider.dart';

import '../data/gallery_model.dart';

class ProjectThumbnail extends StatefulWidget {
  const ProjectThumbnail({
    Key key,
    @required this.thumbnail,
    this.onTap,
  }) : super(key: key);

  final File thumbnail;
  final VoidCallback onTap;

  @override
  _ProjectThumbnailState createState() => _ProjectThumbnailState();
}

class _ProjectThumbnailState extends State<ProjectThumbnail> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    context.watch<Project>();

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        setState(() => _menuOpen = true);
      },
      child: PopupWithArrowEntry(
        visible: _menuOpen,
        arrowSide: ArrowSide.bottom,
        arrowSidePosition: ArrowSidePosition.middle,
        arrowAnchor: Alignment(0, -0.8),
        popupColor: Theme.of(context).colorScheme.primary,
        popupBody: _buildProjectMenu(),
        child: _buildThumbnail(),
        onTapOutside: () {
          setState(() => _menuOpen = false);
        },
      ),
    );
  }

  Widget _buildProjectMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LabeledIconButton(
        icon: FontAwesomeIcons.trashAlt,
        label: 'Move to Bin',
        color: Theme.of(context).colorScheme.onPrimary,
        onTap: () {
          context
              .read<GalleryModel>()
              .moveProjectToBin(context.read<Project>());
        },
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.thumbnail.existsSync()
          ? Image.memory(
              // Temporary fix for this issue https://github.com/flutter/flutter/issues/17419
              widget.thumbnail.readAsBytesSync(),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
          : null,
    );
  }
}
