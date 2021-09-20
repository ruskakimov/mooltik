import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';

class GroupLinesLayer extends StatelessWidget {
  const GroupLinesLayer({
    Key? key,
    required this.layerGroups,
    required this.scrollOffset,
    required this.rowHeight,
  }) : super(key: key);

  final List<LayerGroupInfo> layerGroups;
  final double scrollOffset;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: _BracketsPainter(
          bracketAreas: layerGroups.map((group) => _getBracketArea(group)),
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 4,
        ),
      ),
    );
  }

  static const double _bracketWidth = 12;
  static const double _vPadding = 24;

  Rect _getBracketArea(LayerGroupInfo groupInfo) {
    final top = rowHeight * groupInfo.firstLayerIndex - scrollOffset;
    final height = rowHeight * groupInfo.layerCount;

    return Rect.fromLTWH(
      0,
      top + _vPadding,
      _bracketWidth,
      height - _vPadding * 2,
    );
  }
}

class _BracketsPainter extends CustomPainter {
  _BracketsPainter({
    required this.bracketAreas,
    required this.color,
    required this.strokeWidth,
  }) : _bracketPaint = Paint()..color = color;

  final Iterable<Rect> bracketAreas;
  final Color color;
  final double strokeWidth;

  final Paint _bracketPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasArea = Rect.fromLTWH(0, 0, size.width, size.height);

    bracketAreas
        .where((area) => area.overlaps(canvasArea))
        .forEach((area) => _paintBracket(canvas, area));
  }

  void _paintBracket(Canvas canvas, Rect area) {
    final mid = area.topLeft & Size(strokeWidth, area.height);
    final top = area.topLeft & Size(area.width, strokeWidth);
    final bottom = area.bottomLeft.translate(0, -strokeWidth) &
        Size(area.width, strokeWidth);

    canvas.drawRect(mid, _bracketPaint);
    canvas.drawRect(top, _bracketPaint);
    canvas.drawRect(bottom, _bracketPaint);
  }

  @override
  bool shouldRepaint(_BracketsPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_BracketsPainter oldDelegate) => false;
}
