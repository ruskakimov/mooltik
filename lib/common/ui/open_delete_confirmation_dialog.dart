import 'package:flutter/material.dart';

Future<bool?> openDeleteConfirmationDialog({
  required BuildContext context,
  required String name,
  required Widget preview,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete this $name?'),
      content: Container(
        width: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: preview,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('DELETE FOREVER'),
        ),
      ],
    ),
  );
}
