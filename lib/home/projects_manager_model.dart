import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class ProjectsManagerModel extends ChangeNotifier {
  Directory _directory;
  List<Project> _projects;

  int get numberOfProjects => _projects?.length;

  Future<void> init(Directory directory) async {
    _directory = directory;
    await _readProjects();
  }

  Future<void> _readProjects() async {
    _projects = [];
    await for (final FileSystemEntity dir in _directory.list()) {
      if (dir is Directory && p.basename(dir.path).startsWith('project_')) {
        _projects.add(Project(dir));
      }
    }

    // Recent projects first.
    _projects.sort((p1, p2) => p2.id - p1.id);

    notifyListeners();
  }

  Project getProject(int index) => _projects[index];

  Future<Project> addProject() async {
    if (_projects == null) throw Exception('Read projects first.');

    final String folderName = 'project_${_projects.length}';
    final Directory dir =
        await Directory(p.join(_directory.path, folderName)).create();
    final Project project = Project(dir);

    _projects.insert(0, project);

    notifyListeners();
    return project;
  }
}

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last);

  final Directory directory;

  final int id;
}
