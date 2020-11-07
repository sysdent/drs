import 'package:flutter/material.dart';
import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SearcherTemplate<E extends EntityModel> extends StatefulWidget {
  bool isSearching = false;
  List<E> itemList;
  int count = 0;
  DatabaseHelper dbHelper = new DatabaseHelper();
  _SearcherTemplateState state;
  int selectedIndex = -1;
  bool deleted = false;
  Function refresh;
  Map<String, dynamic> params;
  User user;

  SearcherTemplate(this.user);


  void setParams(Map<String, dynamic> params){
    this.params = params;
  }

  void setRefresh(Function refresh){
    this.refresh = refresh;
  }

  void setSearchMode(searchMode) {
    this.isSearching = searchMode;
  }

  Future<List<E>> getList(Database db, String nameFilter) async {
    return null;
  }

  Widget getEditScreen(Map<String, dynamic> params, E entityModel) {
    return null;
  }

  void goToEdit(BuildContext context, E entityModel) async {
    Map<String, dynamic> params = await initEditView(entityModel);
    bool isSuccessfully =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      //return EditProject(null);
      return getEditScreen(params, entityModel);
    }));
    //if (isSuccessfully != null && isSuccessfully) {
      state.updateListView();
    //}
  }

  Future<Map<String, dynamic>> initEditView(E entityModel) async {
    return null;
  }

  Future<EntityModel> delete(){
    if(selectedIndex >= 0){
      return deleteItem( itemList[selectedIndex] );
    }
    return null;
  }

  Future<EntityModel> deleteItem( E entityModel ){
    return null;
  }

  ListTile getListTile(E entityModel) {
    return ListTile(
      title: Text(entityModel.name),
    );
  }

  @override
  _SearcherTemplateState createState() {
    state = _SearcherTemplateState();
    return state;
  }
}

class _SearcherTemplateState<E extends EntityModel>
    extends State<SearcherTemplate> {

  @override
  Widget build(BuildContext context) {

    this.widget.setRefresh(()=>setState(() {}));

    if (widget.itemList == null || widget.deleted) {
      updateListView();
      widget.deleted = false;
    }
    return getProjectListView();
  }

  getProjectListView() {
    return ListView.builder(
        itemCount: widget.count,
        itemBuilder: (BuildContext context, int position) {
          return GestureDetector(
            child: Card(
              color: position == widget.selectedIndex ? Colors.white38 : Colors.white,
              elevation: 2.0,
              child: widget.getListTile(widget.itemList[position]),
            ),
            onTap: (){
              widget.goToEdit(context, widget.itemList[position]);
            },
            onLongPress: (){
              setState(() {
                widget.selectedIndex = position;
              });
            },
          );
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = widget.dbHelper.initializeDatabase();
    dbFuture.then((database) {
      var projectListFuture = widget.getList(database, null);
      // Project.list(database, null);
      projectListFuture.then((list) {
        setState(() {
          widget.itemList = list;
          widget.count = list.length;
        });
      });
    });
  }
}
