import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/factor/edit_factor.dart';
import 'package:perforaya/utils/alert.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditProject extends StatefulWidget {
  Project _project;
  DatabaseHelper dbHelper = new DatabaseHelper();
  int total = null;
  User _user;

  EditProject(this._project, this._user);

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  int _currentScreen = 0;

  TextEditingController nameController = TextEditingController();

  TextEditingController wellnameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController depthController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController startdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget._project != null && widget.total == null) {
      widget.dbHelper.database.then((db) {
        Factor.listByProject(db, widget._project.id).then((factors) {
          double totalAux = 0;
          factors.forEach((factor) {
            if (factor.type != ECONOMIC) totalAux += factor.weight;
          });
          setState(() {
            widget.total = totalAux.round();
          });
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget._project == null ? "Crear proyecto" : "Editar proyecto"),
      ),
      body: getScreen(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  BottomNavigationBar getBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentScreen,
      type: BottomNavigationBarType.fixed,
      items: getTabs(),
      onTap: (index) {
        setState(() {
          _currentScreen = index;
        });
      },
    );
  }

  List<BottomNavigationBarItem> getTabs() {
    var tabs = [
      BottomNavigationBarItem(
        icon: Icon(Icons.info),
        title: Text(""),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text(""),
      ),
    ];
    return tabs;
  }

  getScreen() {
    if (_currentScreen == 1) {
      return getRequirementsScreen();
    }
    return getInfoScreen();
  }

  getInfoScreen() {
    wellnameController..text = widget._project?.wellname;
    locationController..text = widget._project?.location;
    areaController..text = widget._project?.area;
    depthController..text = widget._project?.depth;
    companyController..text = widget._project?.company;
    startdateController..text = widget._project?.startdate;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(2.0),
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(2.0),
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  "Información del pozo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Nombre del pozo"),
                  controller: wellnameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Localización actual"),
                  controller: locationController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Área de trabajo"),
                  controller: areaController,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "Máxima profundidad del pozo"),
                  controller: depthController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Compañía operadora"),
                  controller: companyController,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "Fecha de inicio del pozo"),
                  controller: startdateController,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text("Guardar"),
                        onPressed: saveProject,
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getRequirementsScreen() {
    nameController..text = widget._project?.name;
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(2.0),
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Nombre"),
                controller: nameController,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Guardar"),
                      onPressed: saveProject,
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  )
                ],
              ),
              if (widget._project != null)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    FACTORES,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              if (widget._project != null && widget.total != 100)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    "La suma de los porcentajes no es igual a 100%, por favor revisar los valores ingresados",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              if (widget._project != null)
                Expanded(
                  child: Container(
                    child: FutureBuilder<List<Factor>>(
                      future: Factor.listByProjectHelper(
                          widget.dbHelper, widget._project.id),
                      initialData: List(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Container(
                                //color: Colors.pinkAccent,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    Factor factor = snapshot.data[i];
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(factor.name),
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 20,
                                                    bottom: 20,
                                                    right: 10),
                                              ),
                                            ),
                                            if (factor.type != ECONOMIC)
                                              Container(
                                                child: CircleAvatar(
                                                  child: Text(
                                                    "${factor.weight.round()}%",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.blue,
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                              ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        widget.total = null;
                                        var db = await widget.dbHelper.database;
                                        var projects =
                                            await Project.list(db, null);
                                        bool isSuccessfully =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditFactor(
                                                  factor, this.widget._project);
                                            },
                                          ),
                                        );
                                        if (isSuccessfully != null &&
                                            isSuccessfully) {
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  saveProject() async {
    if (nameController.text.toString().isEmpty) {
      alert(context, "Error",
          "Por favor diligencie el nombre del proyecto en la pestaña de Requerimientos.");
      return;
    }

    if (widget._project == null) {
      widget._project = Project(0, nameController.text.toString());
      widget._project.user = widget._user.id;
    } else {
      widget._project.name = nameController.text.toString();
    }

    widget._project.wellname = wellnameController.text.toLowerCase();
    widget._project.location = locationController.text.toLowerCase();
    widget._project.area = areaController.text.toLowerCase();
    widget._project.depth = depthController.text.toLowerCase();
    widget._project.company = companyController.text.toLowerCase();
    widget._project.startdate = startdateController.text.toLowerCase();

    var db = await widget.dbHelper.database;
    await Project.save(db, widget._project);
    Navigator.pop(context, true);
  }
}
