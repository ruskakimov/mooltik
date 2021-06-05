import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/editor_model.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/actionbar/editing_actionbar.dart';
import 'package:mooltik/editing/ui/preview/description_area.dart';
import 'package:mooltik/editing/ui/preview/preview.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/timeline_panel.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    context.read<RouteObserver>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Refresh visible frames.
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EditorModel(
            sceneSeq: context.read<Project>().scenes,
            writeToDisk: context.read<Project>().updateSaveDataOnDisk,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TimelineModel(
            sceneSeq: context.read<Project>().scenes!,
            vsync: this,
          ),
        ),
        ChangeNotifierProvider<PlayerModel>(
          create: (context) => PlayerModel(
            soundClips: context.read<Project>().soundClips,
            timeline: context.read<TimelineModel>(),
          ),
        ),
        ChangeNotifierProvider<TimelineViewModel>(
          create: (context) => TimelineViewModel(
            timeline: context.read<TimelineModel>(),
            soundClips: context.read<Project>().soundClips,
            sharedPreferences: context.read<SharedPreferences>(),
            createNewFrame: context.read<Project>().createNewFrame,
          ),
        ),
      ],
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
                  child: EditingTopPanel(),
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

class EditingTopPanel extends StatelessWidget {
  const EditingTopPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final sceneNumber = context.watch<TimelineModel>().currentSceneNumber;
    final sceneDesciption =
        context.watch<TimelineModel>().currentScene.description;

    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditingActionbar(
          title: Text(
            isPortrait ? 'Scene $sceneNumber' : '$sceneNumber',
            style: TextStyle(
              fontSize: 18,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          direction: isPortrait ? Axis.horizontal : Axis.vertical,
        ),
        Expanded(
          flex: isPortrait ? 2 : 0, // Good enough cross-device solution.
          child: Preview(),
        ),
        Expanded(
          flex: 1,
          child: DescriptionArea(
            description: sceneDesciption,
            textAlign: isPortrait ? TextAlign.center : TextAlign.left,
            onDone: (newDescription) {
              final editor = context.read<EditorModel>();
              editor.changeCurrentSceneDescription(newDescription);
            },
          ),
        ),
      ],
    );
  }
}
