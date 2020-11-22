import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';

class ReelRow extends StatelessWidget {
  const ReelRow({
    Key key,
    @required this.frame,
    @required this.selected,
  }) : super(key: key);

  final FrameModel frame;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: FrameThumbnail(frame: frame),
          ),
          SizedBox(
            width: 48,
            child: selected
                ? _DurationPicker(
                    initialValue: frame.duration,
                    onSelectedItemChanged: (int value) {
                      frame.duration = value;
                    },
                  )
                : _buildDurationLabel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationLabel(BuildContext context) {
    return Center(
      child: Text(
        '${frame.duration}',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _DurationPicker extends StatefulWidget {
  const _DurationPicker({
    Key key,
    @required this.initialValue,
    @required this.onSelectedItemChanged,
  }) : super(key: key);

  final int initialValue;
  final void Function(int) onSelectedItemChanged;

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<_DurationPicker> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        FixedExtentScrollController(initialItem: widget.initialValue - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      scrollController: _controller,
      itemExtent: 20,
      onSelectedItemChanged: (int index) =>
          widget.onSelectedItemChanged?.call(index + 1),
      childCount: 24,
      useMagnifier: false,
      magnification: 1,
      squeeze: 1,
      itemBuilder: (context, index) => Text(
        '${index + 1}',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
