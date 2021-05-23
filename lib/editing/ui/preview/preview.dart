import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/drawing/drawing_page.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:provider/provider.dart';

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<TimelineViewModel>(); // Listen to visibility toggle.

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Listener(
          onPointerDown: (_) {
            final project = context.read<Project>();
            final timeline = context.read<TimelineModel>();

            if (timeline.isPlaying) return;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: project),
                    ChangeNotifierProvider.value(value: timeline),
                  ],
                  child: DrawingPage(),
                ),
              ),
            );
          },
          child: FittedBox(
            fit: BoxFit.contain,
            child: _buildImage(context),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final image = context.select<TimelineModel, CompositeImage>(
      (timeline) => timeline.currentFrame,
    );
    return CustomPaint(
      size: image.size,
      painter: CompositeImagePainter(
        context.select<TimelineModel, CompositeImage>(
          (timeline) => timeline.currentFrame,
        ),
      ),
    );
  }
}
