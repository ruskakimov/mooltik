import 'package:flutter/material.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({Key key, this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 44,
        child: Center(
          child: ClipOval(
            child: CustomPaint(
              painter: TileBackgroundPainter(),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: toolbox.selectedColor,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TileBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Size tileSize = Size(size.width / 7, size.height / 7);
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
