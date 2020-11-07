import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/equipment/edit_equipment.dart';
import 'package:perforaya/ui/project/edit_project.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:perforaya/ui/system/edit_system.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class EquipmentList extends SearcherTemplate<Equipment> {
  EquipmentList(User user) : super(user);


  @override
  Future<List<Equipment>> getList(Database db, String nameFilter) {
    return Equipment.list(db, null);
  }

  Widget getEditScreen(Map<String, dynamic> params, Equipment equipment) {
    return EditEquipment(equipment, null);
  }

  @override
  Future<Map<String, dynamic>> initEditView(Equipment equipment) async{
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  @override
  Future<Equipment> deleteItem(Equipment equipment) async{
    var db = await dbHelper.database;
    int rowsDeleted = await Equipment.delete(db, equipment);
    if( rowsDeleted > 0 ){
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => equipment);
    }
    return null;
  }

  @override
  ListTile getListTile(Equipment equipment) {
    return ListTile(
      title: Text(equipment.name),
      trailing: CircleAvatar(
        child: Text(
          "${equipment.weight.round()}%",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}