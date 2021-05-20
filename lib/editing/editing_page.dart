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
    final sceneNumber = context.watch<TimelineModel>().currentSceneNumber;

    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditingActionbar(
          title: Text(
            isPortrait ? 'Scene $sceneNumber' : '$sceneNumber',
            style: TextStyle(fontSize: 18),
          ),
          direction: isPortrait ? Axis.horizontal : Axis.vertical,
        ),
        Preview(),
        Expanded(
          child: DescriptionArea(
            description: 'Hello ' * 300,
          ),
        ),
      ],
    );
  }
}

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
