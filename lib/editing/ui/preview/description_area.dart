import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/edit_text_dialog.dart';

class DescriptionArea extends StatelessWidget {
  const DescriptionArea({
    Key? key,
    this.description,
    this.onDone,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String? description;
  final ValueChanged<String>? onDone;
  final TextAlign textAlign;

  bool get emptyDescription => description == null || description == '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () => _openEditDialog(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: emptyDescription
                ? _buildPlaceholder(context)
                : Text(
                    description!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                    ),
                    textAlign: textAlign,
                  ),
          ),
        ),
        _buildTopShadow(context),
        _buildBottomShadow(context),
      ],
    );
  }

  void _openEditDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditTextDialog(
          title: 'Scene description',
          initialValue: description ?? '',
          onSubmit: (value) {
            onDone?.call(value);
          },
          maxLines: 5,
          maxLength: 300,
        ),
      ),
    );
  }

  Text _buildPlaceholder(BuildContext context) {
    return Text(
      'Tap to add scene description',
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 14,
        height: 1.2,
      ),
      textAlign: textAlign,
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
