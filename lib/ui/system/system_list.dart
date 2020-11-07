import 'package:flutter/material.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:perforaya/ui/system/edit_system.dart';
import 'package:sqflite/sqflite.dart';

class SystemList extends SearcherTemplate<System> {
  SystemList(User user) : super(user);

  @override
  Future<List<System>> getList(Database db, String nameFilter) {
    return System.list(db, null);
  }

  Widget getEditScreen(Map<String, dynamic> params, System system) {
    return EditSystem(system, null);
  }

  @override
  Future<Map<String, dynamic>> initEditView(System system) async {
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  @override
  Future<System> deleteItem(System system) async {
    var db = await dbHelper.database;
    int rowsDeleted = await System.delete(db, system);
    if (rowsDeleted > 0) {
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => system);
    }
    return null;
  }

  @override
  ListTile getListTile(System system) {
    return ListTile(
      title: Text(system.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(system.projectName),
          Text(system.factorName),
        ],
      ),
      trailing: CircleAvatar(
        child: Text(
          "${system.weight.round()}%",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
