import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/pencil.dart';
import 'package:mooltik/drawing/ui/color_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class SizePicker extends StatelessWidget {
  const SizePicker({
    Key key,
    this.pickerRadius = 60,
    this.smallestInnerCircleRadius = 5,
    this.dragSensitivity = 0.4,
  }) : super(key: key);

  final double pickerRadius;
  final double smallestInnerCircleRadius;
  final double dragSensitivity;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        final toolWidthRange = toolbox.selectedTool.maxStrokeWidth -
            toolbox.selectedTool.minStrokeWidth;
        final innerCircleRadiusRange = pickerRadius - smallestInnerCircleRadius;

        final strokeWidthDelta = -details.delta.dy /
            innerCircleRadiusRange *
            toolWidthRange *
            dragSensitivity;

        toolbox.changeToolStrokeWidth(
            toolbox.selectedToolStrokeWidth + strokeWidthDelta);
      },
      child: InkResponse(
        radius: pickerRadius / 2,
        highlightColor: Colors.white70,
        splashColor: Colors.transparent,
        onTap: () {
          if (toolbox.selectedTool is Pencil) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => ChangeNotifierProvider.value(
                value: toolbox,
                child: ColorPickerDialog(),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            _Circle(
              radius: pickerRadius,
              color: Color(0xC4C4C4).withOpacity(0.5),
            ),
            _Circle(
              radius: _calcInnerCircleRadius(
                toolbox.selectedToolStrokeWidth,
                toolbox.selectedTool.minStrokeWidth,
                toolbox.selectedTool.maxStrokeWidth,
              ),
              color: toolbox.selectedToolColor,
              border: Border.all(color: Colors.white),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.none,
                  child: CustomPaint(
                    size: Size.square(pickerRadius),
                    painter: _TileBackgroundPainter(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calcInnerCircleRadius(
    double value,
    double minValue,
    double maxValue,
  ) {
    final fraction = (value - minValue) / (maxValue - minValue);
    return smallestInnerCircleRadius +
        (pickerRadius - smallestInnerCircleRadius) * fraction;
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    Key key,
    @required this.radius,
    @required this.color,
    this.border,
    this.child,
  }) : super(key: key);

  final double radius;
  final Color color;
  final BoxBorder border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      foregroundDecoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
      ),
      child: child,
    );
  }
}

class _TileBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Size tileSize = Size(size.width / 13, size.height / 13);
    final Paint greyPaint = Paint()..color = const Color(0xFFCCCCCC);
    final Paint whitePaint = Paint()..color = Colors.white;
    List.generate((size.height / tileSize.height).round(), (int y) {
      List.generate((size.width / tileSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(tileSize.width * x, tileSize.height * y) & tileSize,
          (x + y) % 2 != 0 ? whitePaint : greyPaint,
        );
      });
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
