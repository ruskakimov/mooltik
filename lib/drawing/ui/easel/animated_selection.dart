import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class AnimatedSelection extends StatefulWidget {
  const AnimatedSelection({
    Key key,
    @required this.selection,
  }) : super(key: key);

  final Path selection;

  @override
  _AnimatedSelectionState createState() => _AnimatedSelectionState();
}

class _AnimatedSelectionState extends State<AnimatedSelection>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print('restart animation');
          controller.reset();
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: widget.selection.getBounds().size,
          painter: SelectionPainter(
            selection: widget.selection,
            animationProgress: controller.value,
          ),
        );
      },
    );
  }
}

class SelectionPainter extends CustomPainter {
  SelectionPainter({
    @required this.selection,
    @required this.animationProgress,
  });

  final Path selection;
  final double animationProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeWidth = 1;

    canvas.drawPath(
      selection,
      paint..color = Colors.white,
    );

    canvas.drawPath(
      dashPath(
        selection,
        dashArray: CircularIntervalList<double>(<double>[
          5.0,
          6.0,
        ]),
        dashOffset: DashOffset.absolute(-11 * animationProgress),
      ),
      paint..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) =>
      oldDelegate.selection != selection ||
      oldDelegate.animationProgress != animationProgress;

  @override
  bool shouldRebuildSemantics(SelectionPainter oldDelegate) => false;
}
