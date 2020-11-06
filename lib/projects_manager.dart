import 'dart:io';
import 'package:path/path.dart' as p;

class ProjectsManager {
  ProjectsManager(this.directory);

  final Directory directory;

  List<Project> _projects;

  int get numberOfProjects => _projects?.length ?? 0;

  Future<void> readProjects() async {
    _projects = [];

    await for (final FileSystemEntity dir in directory.list()) {
      if (dir is Directory && p.basename(dir.path).startsWith('project_')) {
        _projects.insert(0, Project(dir));
      }
    }
  }

  Future<Project> addProject() async {
    final Directory dir =
        await Directory(p.join(directory.path, 'project_0')).create();
    final Project project = Project(dir);

    _projects.insert(0, project);
    return project;
  }
}

class Project {
  Project(this.directory);

  final Directory directory;
}
