import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/actionbar/editing_actionbar.dart';
import 'package:mooltik/editing/ui/preview/preview.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/timeline_panel.dart';
import 'package:mooltik/common/data/project/project.dart';
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
        sceneSeq: context.read<Project>().scenes,
        vsync: this,
        createNewFrame: context.read<Project>().createNewFrame,
      ),
      child: WillPopScope(
        // Disables iOS swipe back gesture. (https://github.com/flutter/flutter/issues/14203)
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Flex(
                    direction: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditingActionbar(
                        direction: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Axis.horizontal
                            : Axis.vertical,
                      ),
                      Expanded(child: Preview()),
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
      ),
    );
  }
}
