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
  FileImage? image;
  DateTime? lastModified;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (widget.thumbnail.existsSync()) {
      image = FileImage(widget.thumbnail);
      lastModified = await widget.thumbnail.lastModified();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.thumbnail.existsSync() && image != null) {
      _refreshImageIfModified();
    } else {
      _init();
    }
  }

  Future<void> _refreshImageIfModified() async {
    final updatedLastModified = await widget.thumbnail.lastModified();

    if (updatedLastModified != lastModified) {
      await image?.evict(cache: imageCache);
      print('evicted');
      lastModified = updatedLastModified;
      setState(() {});
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
        child: _Thumbnail(
          key: Key('$lastModified'),
          image: image,
        ),
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
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    Key? key,
    required this.image,
  }) : super(key: key);

  final FileImage? image;

  @override
  Widget build(BuildContext context) {
    final _image = image;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: frostedGlassColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _image != null
            ? Image(
                image: _image,
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
              )
            : ColoredBox(color: Colors.white),
      ),
    );
  }
}
