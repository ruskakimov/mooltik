import 'package:flutter/material.dart';
import 'package:mooltik/editor/editing_actionbar.dart';
import 'package:mooltik/editor/preview.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/editor/timeline/timeline_panel.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';

class EditingPage extends StatefulWidget {
  static const routeName = '/editor';

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimelineModel(
        frames: context.read<Project>().frames,
        vsync: this,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditingActionbar(),
                    Spacer(),
                    Preview(),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: TimelinePanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
