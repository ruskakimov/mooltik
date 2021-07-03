import 'package:flutter/material.dart';

void openEditDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onDone,
  required Widget body,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                onDone();
                Navigator.of(context).pop();
              },
              tooltip: 'Done',
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    ),
  );
}
