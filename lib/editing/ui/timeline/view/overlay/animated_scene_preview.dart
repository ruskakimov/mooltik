import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';

class AnimatedScenePreview extends StatefulWidget {
  AnimatedScenePreview({
    Key? key,
    required this.scene,
  }) : super(key: key);

  final Scene scene;

  @override
  _AnimatedScenePreviewState createState() => _AnimatedScenePreviewState();
}

class _AnimatedScenePreviewState extends State<AnimatedScenePreview> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
