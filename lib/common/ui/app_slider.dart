import 'package:flutter/material.dart';

class AppSlider extends StatefulWidget {
  const AppSlider({
    Key? key,
    this.height = 44,
    this.value = 0.5,
    this.innerPadding = 3,
    this.icon,
    this.negativeIcon,
    this.onChanged,
  }) : super(key: key);

  final double height;
  final double innerPadding;

  final IconData? icon;
  final IconData? negativeIcon;

  /// Slider value between 0 and 1.
  final double? value;

  final ValueChanged<double>? onChanged;

  @override
  _AppSliderState createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  double? _valueAtDragStart;
  late double _draggedBy;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (DragStartDetails details) {
          _valueAtDragStart = widget.value;
          _draggedBy = 0;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          _draggedBy += details.primaryDelta!;
          final maxWidth = constraints.maxWidth - widget.innerPadding * 2;
          final num newValue =
              (_valueAtDragStart! + _draggedBy / maxWidth).clamp(0.0, 1.0);
          widget.onChanged?.call(newValue as double);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.innerPadding),
              child: Stack(
                children: [
                  _buildProgressBar(),
                  if (widget.icon != null)
                    Align(
                      alignment: Alignment(-0.82, 0.0),
                      child: Icon(
                        widget.value! > 0
                            ? widget.icon
                            : widget.negativeIcon ?? widget.icon,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                ],
              ),
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
            width: constraints.maxWidth * widget.value!,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
