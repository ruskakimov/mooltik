import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';

class ProjectThumbnail extends StatelessWidget {
  const ProjectThumbnail({
    Key key,
    @required this.thumbnail,
    this.onTap,
  }) : super(key: key);

  final File thumbnail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    context.watch<Project>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 180,
        color: Colors.white,
        child: thumbnail.existsSync()
            ? Image.memory(
                // Temporary fix for this issue https://github.com/flutter/flutter/issues/17419
                thumbnail.readAsBytesSync(),
                fit: BoxFit.cover,
                gaplessPlayback: true,
              )
            : null,
      ),
    );
  }
}
