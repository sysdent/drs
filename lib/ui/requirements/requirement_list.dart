import 'package:flutter/material.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/requirements/edit_requirement.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:sqflite/sqflite.dart';

class RequirementList extends SearcherTemplate<Requirement> {
  RequirementList(User user) : super(user);

  @override
  Future<List<Requirement>> getList(Database db, String nameFilter) {
    return Requirement.list(db, null);
  }

  Widget getEditScreen(Map<String, dynamic> params, Requirement requirement) {
    return EditRequirement(requirement, null);
  }

  @override
  Future<Map<String, dynamic>> initEditView(Requirement requirement) async {
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  @override
  Future<Requirement> deleteItem(Requirement requirement) async {
    var db = await dbHelper.database;
    int rowsDeleted = await Requirement.delete(db, requirement);
    if (rowsDeleted > 0) {
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => requirement);
    }
    return null;
  }

  @override
  ListTile getListTile(Requirement requirement) {
    return ListTile(
      title: Text(requirement.label),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("${requirement.expected}  -  ${requirement.equipmentName}"),
        ],
      ),
      /*trailing: CircleAvatar(
        child: Text(
          "${requirement.weight.round()}%",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),*/
    );
  }
}
