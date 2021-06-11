import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

class AnimatedScenePreview extends StatefulWidget {
  AnimatedScenePreview({
    Key? key,
    required this.scene,
  }) : super(key: key);

  final Scene scene;

  @override
  _AnimatedScenePreviewState createState() => _AnimatedScenePreviewState();
}

class _AnimatedScenePreviewState extends State<AnimatedScenePreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this)
      ..repeat(period: widget.scene.duration);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final playhead = widget.scene.duration * animation.value;
        final image = widget.scene.imageAt(playhead);

        return FittedBox(
          fit: BoxFit.contain,
          child: CustomPaint(
            size: image.size,
            painter: CompositeImagePainter(image),
          ),
        );
      },
    );
  }
}
