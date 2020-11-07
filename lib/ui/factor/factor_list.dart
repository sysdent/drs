import 'package:flutter/material.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/factor/edit_factor.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:sqflite/sqflite.dart';

class FactorList extends SearcherTemplate<Factor> {
  FactorList(User user) : super(user);

  @override
  Future<List<Factor>> getList(Database db, String nameFilter) {
    return Factor.list(db, null);
  }

  Widget getEditScreen(Map<String, dynamic> params, Factor factor) {
    return EditFactor(factor, null);
  }

  @override
  Future<Map<String, dynamic>> initEditView(Factor factor) async {
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  @override
  Future<Factor> deleteItem(Factor factor) async {
    var db = await dbHelper.database;
    int rowsDeleted = await Factor.delete(db, factor);
    if (rowsDeleted > 0) {
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => factor);
    }
    return null;
  }

  @override
  ListTile getListTile(Factor factor) {
    return ListTile(
        title: Text(factor.name),
        subtitle: Text(factor.projectName),
        trailing: CircleAvatar(
          child: Text(
            "${factor.weight.round()}%",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ));
  }
}
