import 'package:flutter/material.dart';

class DescriptionArea extends StatelessWidget {
  const DescriptionArea({
    Key key,
    this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: description == null
              ? _buildPlaceholder(context)
              : Text(description),
        ),
        _buildTopShadow(context),
        _buildBottomShadow(context),
      ],
    );
  }

  Text _buildPlaceholder(BuildContext context) {
    return Text(
      'Tap to add scene description',
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
    );
  }

  Positioned _buildTopShadow(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buildBottomShadow(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }
}
