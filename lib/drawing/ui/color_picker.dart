import 'dart:ui';

import 'package:flutter/material.dart';

const _buttonWidth = 40.0;

const _customGreyMaterial = MaterialColor(
  0xFF9E9E9E,
  <int, Color>{
    100: Colors.white,
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  },
);

const _materialColors = <MaterialColor>[
  _customGreyMaterial,
  Colors.blueGrey,
  Colors.brown,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.lime,
  Colors.yellow,
];

const _shades = [100, 300, 400, 500, 700, 900];

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key key,
    @required this.selectedColor,
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final void Function(Color) onSelected;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final columns = orientation == Orientation.portrait
          ? _shades.length
          : _materialColors.length;

      return Container(
        margin: const EdgeInsets.all(8),
        width: _buttonWidth * columns,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: GridView.count(
          primary: false,
          crossAxisCount: columns,
          shrinkWrap: true,
          children: [
            if (orientation == Orientation.portrait)
              for (var color in _materialColors)
                for (var shade in _shades)
                  _ColorOption(
                    color: color[shade],
                    selected: color[shade].value == selectedColor.value,
                    onSelected: onSelected,
                  ),
            if (orientation == Orientation.landscape)
              for (var shade in _shades)
                for (var color in _materialColors.reversed)
                  _ColorOption(
                    color: color[shade],
                    selected: color[shade].value == selectedColor.value,
                    onSelected: onSelected,
                  ),
          ],
        ),
      );
    });
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    Key key,
    @required this.color,
    @required this.selected,
    @required this.onSelected,
  }) : super(key: key);

  final Color color;
  final bool selected;
  final void Function(Color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        onSelected?.call(color);
      },
      child: SizedBox(
        width: _buttonWidth,
        height: _buttonWidth,
        child: selected
            ? _addSelectionRing(ColoredBox(color: color))
            : ColoredBox(color: color),
      ),
    );
  }

  Widget _addSelectionRing(Widget child) => Stack(
        fit: StackFit.expand,
        children: [
          child,
          Container(
            margin: const EdgeInsets.all(2),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 8,
                color: Colors.black38,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
}
