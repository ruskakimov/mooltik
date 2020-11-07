import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/home/project.dart';
import 'package:path/path.dart' as p;

class ProjectsManagerModel extends ChangeNotifier {
  Directory _directory;
  List<Project> _projects;
  IdGenerator _idGenerator;

  int get numberOfProjects => _projects?.length;

  Future<void> init(Directory directory) async {
    _directory = directory;
    _projects = await _readProjects();
    _idGenerator = IdGenerator(directory);
    notifyListeners();
  }

  Future<List<Project>> _readProjects() async {
    final List<Project> projects = [];
    await for (final FileSystemEntity dir in _directory.list()) {
      if (dir is Directory && _validProjectDirectory(dir)) {
        projects.add(Project(dir));
      }
    }
    // Recent projects first.
    projects.sort((p1, p2) => p2.id - p1.id);
    return projects;
  }

  bool _validProjectDirectory(Directory directory) {
    final String folderName = p.basename(directory.path);
    return RegExp(r'^project_[0-9]+$').hasMatch(folderName);
  }

  Project getProject(int index) => _projects[index];

  Future<Project> addProject() async {
    if (_projects == null) throw Exception('Read projects first.');

    final int id = await _idGenerator.generateId();
    final String folderName = 'project_$id';
    final Directory dir =
        await Directory(p.join(_directory.path, folderName)).create();
    final Project project = Project(dir);

    _projects.insert(0, project);

    notifyListeners();
    return project;
  }

  Future<void> deleteProject(int index) async {
    final Project project = _projects.removeAt(index);
    await project.directory.delete(recursive: true);
    notifyListeners();
  }
}

class IdGenerator {
  IdGenerator(this.directory)
      : _file = File(p.join(directory.path, 'last_id.txt'));

  final Directory directory;
  final File _file;

  Future<int> generateId() async {
    final int id = await _readLastId() + 1;
    _writeLastId(id);
    return id;
  }

  Future<int> _readLastId() async {
    if (!await _file.exists()) return -1;

    final String contents = await _file.readAsString();
    return int.parse(contents);
  }

  Future<void> _writeLastId(int lastId) async {
    if (!await _file.exists()) {
      await _file.create();
    }
    await _file.writeAsString('$lastId');
  }
}
