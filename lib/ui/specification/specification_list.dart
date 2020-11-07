import 'package:flutter/material.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:perforaya/ui/specification/edit_specification.dart';
import 'package:sqflite/sqflite.dart';

class SpecificationList extends SearcherTemplate<Specification> {
  SpecificationList(User user) : super(user);

  @override
  Future<List<Specification>> getList(Database db, String nameFilter) {
    return Specification.list(db, null);
  }

  Widget getEditScreen(
      Map<String, dynamic> params, Specification specification) {
    return EditSpecification(specification, null);
  }

  @override
  Future<Map<String, dynamic>> initEditView(Specification specification) async {
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  @override
  Future<Specification> deleteItem(Specification specification) async {
    var db = await dbHelper.database;
    int rowsDeleted = await Specification.delete(db, specification);
    if (rowsDeleted > 0) {
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => specification);
    }
    return null;
  }

  @override
  ListTile getListTile(Specification specification) {
    return ListTile(
      title: Text(specification.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(specification.equipmentName.toString()),
        ],
      ),
      trailing: CircleAvatar(
        child: Text(
          "${specification.weight.round()}%",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
