import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perforaya/ui/login.dart';
import 'package:perforaya/ui/manual_screen.dart';
import 'package:perforaya/ui/offer/offer_list.dart';
import 'package:perforaya/ui/project/project_list.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:perforaya/ui/user/change_password.dart';
import 'package:perforaya/ui/user/user_list.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  int _currentViewIndex = 0;
  String manualPath;
  var _user;
  var isSearcher = true;

  MainScreen(this._currentViewIndex, this._user);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseHelper dbHelper = new DatabaseHelper();
  String _title = "Drilling Rig Selection";
  bool isSearching = false;
  SearcherTemplate currentView;
  Widget _currentPage;
  ProjectList projectList = null;
  OfferList offerList = null;
  UserList userList = null;

  @override
  Widget build(BuildContext context) {

    if( projectList == null ){
      projectList = ProjectList( widget._user );
    }
    if( offerList == null ){
      offerList = OfferList( widget._user );
    }
    if( userList == null ){
      userList = UserList( widget._user );
    }

    if (currentView == null) {
      currentView = projectList;
      _currentPage = projectList;
      _title = "Proyectos";
    }

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                style: TextStyle(
                    //backgroundColor: Colors.white,
                    color: Colors.white),
              )
            : Text(_title),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (this.isSearching) {}
                  this.isSearching = !this.isSearching;
                });
              }),
          if(widget.isSearcher)
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                var deleteResult = this.currentView.delete();
                deleteResult?.then((value) {
                  this.currentView.refresh?.call();
                });
              }),
        ],
      ),
      body: _currentPage,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              //padding: EdgeInsets.only(top: 30, bottom: 20),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "${widget._user.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  CircleAvatar(
                    minRadius: 30,
                    child: Text(
                      "${widget._user.name.toString().substring(0, 1)}",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.white70,
                  ),
                  Container(
                    child: Text(
                      "${widget._user.mail}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
            ),
            ListTile(
              title: Text("Cambiar clave"),
              leading: IconButton(
                icon: Icon(Icons.vpn_key),
              ),
              onTap: () {
                setState(() {
                  _title = "Cambiar clave";
                  widget._currentViewIndex = 3;
                  currentView.selectedIndex = -1;
                  _currentPage = getScreen();
                  currentView.selectedIndex = -1;
                  widget.isSearcher = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Proyectos"),
              leading: IconButton(
                icon: Icon(Icons.folder_special),
              ),
              onTap: () {
                setState(() {
                  _title = "Proyectos";
                  widget._currentViewIndex = 0;
                  currentView.selectedIndex = -1;
                  _currentPage = getScreen();
                  currentView = _currentPage;
                  currentView.selectedIndex = -1;
                  widget.isSearcher = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Ofertas"),
              leading: IconButton(
                icon: Icon(Icons.class_),
              ),
              onTap: () {
                setState(() {
                  _title = "Ofertas";
                  widget._currentViewIndex = 1;
                  currentView.selectedIndex = -1;
                  _currentPage = getScreen();
                  currentView = _currentPage;
                  currentView.selectedIndex = -1;
                  widget.isSearcher = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Manual"),
              leading: IconButton(
                icon: Icon(Icons.help),
              ),
              onTap: () async {
                Directory directory = await getApplicationDocumentsDirectory();
                widget.manualPath =
                    join(directory.path, "ManualDeUsuarioDRS.pdf");
                if (FileSystemEntity.typeSync(widget.manualPath) ==
                    FileSystemEntityType.notFound) {
                  ByteData data =
                      await rootBundle.load("assets/ManualDeUsuarioDRS.pdf");
                  List<int> bytes = data.buffer
                      .asUint8List(data.offsetInBytes, data.lengthInBytes);
                  await File(widget.manualPath).writeAsBytes(bytes);
                }
                Navigator.pop(context);
                bool isSuccessfully = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ManualScreen(widget.manualPath);
                }));
              },
            ),
            ListTile(
              title: Text("Usuarios"),
              leading: IconButton(
                icon: Icon(Icons.person),
              ),
              onTap: () {
                setState(() {
                  _title = "Usuarios";
                  widget._currentViewIndex = 2;
                  currentView.selectedIndex = -1;
                  _currentPage = getScreen();
                  currentView = _currentPage;
                  currentView.selectedIndex = -1;
                  widget.isSearcher = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Salir"),
              leading: IconButton(
                icon: Icon(Icons.exit_to_app),
              ),
              onTap: () async {
                Navigator.pop(context);
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                bool isSuccessfully = await Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(
                  builder: (context) {
                    _prefs.clear();
                    return LoginScreen();
                  },
                ), (Route<dynamic> route) => false);
              },
            ),
            /*ListTile(
              title: Text("Generar DDL"),
              leading: IconButton(
                icon: Icon(Icons.directions_run),
              ),
              onTap: () async {
                String sql = "";

                sql += "--DDL\n";
                var db = await dbHelper.database;
                sql += "--PROYECTOS\n";
                var projects = await Project.list(db, null);
                projects.forEach((element) {
                  sql += Project.getInsert(element) + "\n";
                });
                sql += "--FACTORES\n";
                var factors = await Factor.list(db, null);
                factors.forEach((element) {
                  sql += Factor.getInsert(element) + "\n";
                });
                sql += "--SISTEMAS\n";
                var systems = await System.list(db, null);
                systems.forEach((element) {
                  sql += System.getInsert(element) + "\n";
                });
                sql += "--EQUIPOS\n";
                var equipments = await Equipment.list(db, null);
                equipments.forEach((element) {
                  sql += Equipment.getInsert(element) + "\n";
                });
                sql += "--ESPECIFICACIONES\n";
                var specifications = await Specification.list(db, null);
                specifications.forEach((element) {
                  sql += Specification.getInsert(element) + "\n";
                });
                sql += "--REQUERIMIENTOS\n";
                var rqs = await Requirement.list(db, null);
                rqs.forEach((element) {
                  sql += 'await db.execute("' +
                      Requirement.getInsert(element) +
                      ');"");\n';
                });
                Directory directory = await getExternalStorageDirectory();
                String path = directory.path + 'perforaya.sql';
                File file = File(path);
                file.writeAsString(sql);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Archivo generado en: $path"),
                      );
                    });
              },
            ),*/
          ],
        ),
      ),
      floatingActionButton: widget.isSearcher ? FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => currentView.goToEdit(context, null),
        ),
      ) : null,
    );
  }

  Widget getScreen() {
    if (widget._currentViewIndex == 0) {
      return projectList;
    }
    if (widget._currentViewIndex == 1) {
      return offerList;
    }
    if (widget._currentViewIndex == 2) {
      return userList;
    }
    if (widget._currentViewIndex == 3) {
      return new ChangePassword(widget._user);
    }
  }
}
