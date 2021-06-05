import 'dart:ui';

import 'package:flutter/material.dart';

class FrameNumberBox extends StatelessWidget {
  const FrameNumberBox({
    Key? key,
    required this.selected,
    required this.number,
  }) : super(key: key);

  final bool selected;
  final int? number;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: selected ? Colors.grey[900] : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
