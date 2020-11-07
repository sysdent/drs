import 'package:flutter/material.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/project/edit_project.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:sqflite/sqflite.dart';

class ProjectList extends SearcherTemplate<Project> {

  ProjectList(User user) : super(user);


  @override
  Future<List<Project>> getList(Database db, String nameFilter) {
    return Project.listProjects(db, null, user.id);
  }

  Widget getEditScreen(Map<String, dynamic> params, Project project) {
    return EditProject(project, user);
  }

  @override
  Future<Project> deleteItem(Project project) async{
    var db = await dbHelper.database;
    int rowsDeleted = await Project.delete(db, project);
    if( rowsDeleted != null && rowsDeleted > 0 ){
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => project);
    }
    return null;
  }
}