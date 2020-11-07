import 'package:flutter/material.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:perforaya/ui/user/edit_user.dart';
import 'package:sqflite/sqflite.dart';

class UserList extends SearcherTemplate<User> {
  UserList(User user) : super(user);


  @override
  Future<List<User>> getList(Database db, String nameFilter) {
    return User.list(db, null);
  }

  Widget getEditScreen(Map<String, dynamic> params, User user) {
    return EditUser(user);
  }

  @override
  Future<User> deleteItem(User user) async{
    var db = await dbHelper.database;
    int rowsDeleted = await User.delete(db, user);
    if( rowsDeleted != null && rowsDeleted > 0 ){
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => user);
    }
    return null;
  }
}