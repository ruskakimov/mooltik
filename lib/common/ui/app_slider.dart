import 'package:flutter/material.dart';

class AppSlider extends StatefulWidget {
  const AppSlider({
    Key key,
    this.height = 44,
    this.value = 0.5,
    this.onChanged,
  }) : super(key: key);

  final double height;

  /// Slider value between 0 and 1.
  final double value;

  final ValueChanged<double> onChanged;

  @override
  _AppSliderState createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  double _valueAtDragStart;
  double _draggedBy;

  @override
  Widget build(BuildContext context) {
    print('build ${widget.value}');
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          _valueAtDragStart = widget.value;
          _draggedBy = 0;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          _draggedBy += details.primaryDelta;
          final newValue =
              (_valueAtDragStart + _draggedBy / constraints.maxWidth)
                  .clamp(0.0, 1.0);
          widget.onChanged?.call(newValue);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: _buildProgressBar(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProgressBar() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * widget.value,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
