import 'package:flutter/material.dart';
import 'package:mooltik/editor/editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: TextButton(
          child: Text('Open Editor'),
          onPressed: () {
            Navigator.of(context).pushNamed(EditorPage.routeName);
          },
        ),
      ),
    );
  }
}
