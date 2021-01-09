import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';

class ProjectThumbnail extends StatelessWidget {
  const ProjectThumbnail({
    Key key,
    @required this.thumbnail,
  }) : super(key: key);

  final File thumbnail;

  @override
  Widget build(BuildContext context) {
    context.watch<Project>();

    return Container(
      width: 200,
      height: 200,
      color: Colors.white,
      child: thumbnail.existsSync()
          ? Image.memory(
              // Temporary fix for this issue https://github.com/flutter/flutter/issues/17419
              thumbnail.readAsBytesSync(),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
          : null,
    );
  }
}
