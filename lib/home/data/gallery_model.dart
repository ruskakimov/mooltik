import 'dart:io';
import 'package:io/io.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/editing/editing_page.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class GalleryModel extends ChangeNotifier {
  late Directory _directory;
  List<Project> _projects = [];

  List<Project> get projects =>
      _projects.where((project) => !project.binned).toList();

  List<Project> get binnedProjects =>
      _projects.where((project) => project.binned).toList();

  Future<void> init(Directory directory) async {
    _directory = directory;
    _projects = await _readProjects();
    notifyListeners();
  }

  Future<List<Project>> _readProjects() async {
    final List<Project> projects = [];
    await for (final FileSystemEntity dir in _directory.list()) {
      if (dir is Directory && Project.validProjectDirectory(dir)) {
        projects.add(Project(dir));
      }
    }
    // Recent projects first.
    projects.sort((p1, p2) => p2.creationEpoch - p1.creationEpoch);
    return projects;
  }

  Future<Project> addProject() async {
    final project = Project.createIn(_directory);
    _projects.insert(0, project);

    notifyListeners();
    return project;
  }

  Project? _openedProject;

  /// Opens one project at a time.
  /// Returns a future when the current project has been closed and another project can be opened.
  Future<void> openProject(Project project, BuildContext context) async {
    if (_openedProject != null) return;
    if (project.isOpen) return;

    _openedProject = project;

    try {
      await project.open();

      final route = MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<Project>.value(
          value: project,
          child: EditingPage(),
        ),
      );

      Navigator.of(context).push(route);

      // Await for pop animation to finish.
      await route.completed;

      // Don't await for save to finish. Allow other projects to be opened immediately.
      project.saveAndClose();
    } catch (e) {
      rethrow;
    } finally {
      _openedProject = null;
    }
  }

  Future<void> moveProjectToBin(Project project) async {
    if (!_projects.contains(project)) {
      throw Exception('Project instance not found.');
    }

    final i = _projects.indexOf(project);
    final newDirName = Project.directoryName(project.creationEpoch, true);
    final newProjectPath = p.join(_directory.path, newDirName);

    _projects[i] = Project(project.directory.renameSync(newProjectPath));
    notifyListeners();
  }

  Future<Project> duplicateProject(Project project) async {
    if (!_projects.contains(project)) {
      throw Exception('Project instance not found.');
    }

    final duplicate = Project.createIn(_directory);
    await copyPath(project.directory.path, duplicate.directory.path);
    _projects.insert(0, duplicate);

    notifyListeners();
    return duplicate;
  }

  Future<void> deleteProject(Project project) async {
    if (!_projects.contains(project))
      throw Exception('Project instance not found.');
    if (!project.binned)
      throw Exception('Cannot delete project outside of bin.');

    _projects.remove(project);
    await project.directory.delete(recursive: true);
    notifyListeners();
  }

  Future<void> restoreProject(Project project) async {
    if (!_projects.contains(project))
      throw Exception('Project instance not found.');
    if (!project.binned)
      throw Exception('Cannot restore project outside of bin.');

    final i = _projects.indexOf(project);
    final newDirName = Project.directoryName(project.creationEpoch, false);
    final newProjectPath = p.join(_directory.path, newDirName);

    _projects[i] = Project(project.directory.renameSync(newProjectPath));
    notifyListeners();
  }
}
