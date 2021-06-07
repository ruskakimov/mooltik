import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';
import 'package:provider/provider.dart';

import '../data/gallery_model.dart';

class ProjectThumbnail extends StatefulWidget {
  const ProjectThumbnail({
    Key? key,
    required this.thumbnail,
    this.onTap,
  }) : super(key: key);

  final File thumbnail;
  final VoidCallback? onTap;

  @override
  _ProjectThumbnailState createState() => _ProjectThumbnailState();
}

class _ProjectThumbnailState extends State<ProjectThumbnail> {
  bool _menuOpen = false;
  late final FileImage image;
  late DateTime lastModified;

  @override
  void initState() {
    super.initState();
    image = FileImage(widget.thumbnail);
    _initLastModified();
  }

  Future<void> _initLastModified() async {
    lastModified = await widget.thumbnail.lastModified();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateImageIfNecessary();
  }

  Future<void> _updateImageIfNecessary() async {
    final updatedLastModified = await widget.thumbnail.lastModified();

    if (updatedLastModified != lastModified) {
      await image.evict(cache: imageCache);
      lastModified = updatedLastModified;
    }
  }

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
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: frostedGlassColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image(
          image: image,
          fit: BoxFit.cover,
          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              child: child,
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
    );
  }
}
