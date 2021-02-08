import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:provider/provider.dart';

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
      child: PopupEntry(
        visible: _menuOpen,
        childAnchor: Alignment.topCenter,
        popupAnchor: Alignment.center,
        popup: _buildProjectMenu(),
        child: _buildThumbnail(),
        onTapOutside: () {
          setState(() => _menuOpen = false);
        },
      ),
    );
  }

  Widget _buildProjectMenu() {
    return PopupWithArrow(
      width: 200,
      child: SizedBox(height: 60),
      arrowSide: ArrowSide.left,
      // arrowPosition: ArrowPosition.end,
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 320,
      height: 180,
      color: Colors.white,
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
