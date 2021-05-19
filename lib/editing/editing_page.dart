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
    with SingleTickerProviderStateMixin, RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<RouteObserver>().subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    // Refresh visible frames.
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimelineModel(
        sceneSeq: context.read<Project>().scenes,
        vsync: this,
      ),
      child: WillPopScope(
        // Disables iOS swipe back gesture. (https://github.com/flutter/flutter/issues/14203)
        onWillPop: () async => true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PreviewArea(),
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

class PreviewArea extends StatelessWidget {
  const PreviewArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditingActionbar(
          title: Text(
            isPortrait ? 'Scene 1' : '1',
            style: TextStyle(fontSize: 18),
          ),
          direction: isPortrait ? Axis.horizontal : Axis.vertical,
        ),
        Preview(),
        Expanded(child: NoteArea()),
      ],
    );
  }
}

class NoteArea extends StatelessWidget {
  const NoteArea({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Boat in the distance hidden behind the fog. \n*sea noises*'),
    );
  }
}
