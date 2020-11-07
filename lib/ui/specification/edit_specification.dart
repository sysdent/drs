import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/ui/requirements/edit_requirement.dart';
import 'package:perforaya/ui/requirements/requirements_by_equipment_dialog.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditSpecification extends StatefulWidget {
  Equipment _equipment;
  Specification _specification;
  DatabaseHelper dbHelper = new DatabaseHelper();

  EditSpecification(this._specification, this._equipment);

  @override
  _EditSpecificationState createState() => _EditSpecificationState();
}

class _EditSpecificationState extends State<EditSpecification> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController..text = this.widget._specification?.name;
    TextEditingController weightController = TextEditingController();
    weightController..text = this.widget._specification?.weight?.toString();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.widget._specification == null
                  ? "Crear especificación"
                  : "Editar especificación"),
              Text(
                "$EQUIPMENT: ${widget._equipment.name}",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () async {
                var db = await widget.dbHelper.database;
                var theEquipment = await Equipment.getById(
                    db, widget._specification.equipment);
                var listByProjectFactorSystemEquipmentAndSpecification =
                    await Requirement
                        .listByProjectFactorSystemEquipmentAndSpecification(
                  db,
                  widget._specification.project,
                  widget._specification.factor,
                  widget._specification.system,
                  widget._specification.equipment,
                  widget._specification.id,
                );
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: RequirementsByEquipmentDialog(theEquipment,
                            listByProjectFactorSystemEquipmentAndSpecification),
                      );
                    }).then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
        floatingActionButton: this.widget._specification == null
            ? null
            : FloatingActionButton(

                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var db = await this.widget.dbHelper.database;
                    bool isSuccessfully = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          //return EditProject(null);
                          return EditRequirement(null, widget._specification);
                        },
                      ),
                    );
                    if (isSuccessfully != null && isSuccessfully) {
                      setState(() {});
                    }
                  },
                ),
              ),
        body: Container(
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
                  TextField(
                    decoration: InputDecoration(labelText: "Porcentaje"),
                    controller: weightController,
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text("Guardar"),
                          onPressed: () async {
                            if (this.widget._specification == null) {
                              this.widget._specification = Specification(
                                  0,
                                  this.widget._equipment.project,
                                  this.widget._equipment.factor,
                                  this.widget._equipment.system,
                                  this.widget._equipment.id,
                                  nameController.text.toString(),
                                  double.parse(
                                      weightController.text.toString()));
                            } else {
                              this.widget._specification.project =
                                  this.widget._equipment.project;
                              this.widget._specification.factor =
                                  this.widget._equipment.factor;
                              this.widget._specification.system =
                                  this.widget._equipment.system;
                              this.widget._specification.equipment =
                                  this.widget._equipment.id;

                              this.widget._specification.name =
                                  nameController.text.toString();
                              this.widget._specification.weight = double.parse(
                                  weightController.text.toString());
                            }
                            var db = await this.widget.dbHelper.database;
                            await Specification.save(
                                db, this.widget._specification);
                            Navigator.pop(context, true);
                            //_scaffoldKey.currentState.showSnackBar(new SnackBar(
                            //    content: new Text("Operación exitosa")));
                          },
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
                  if (widget._specification != null)
                    Expanded(
                      child: FutureBuilder<List<Requirement>>(
                        future: Requirement
                            .listByProjectFactorSystemEquipmentAndSpecificationHelper(
                                widget.dbHelper,
                                widget._specification.project,
                                widget._specification.factor,
                                widget._specification.system,
                                widget._specification.equipment,
                                widget._specification.id),
                        initialData: List(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    Requirement requirement = snapshot.data[i];
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(requirement.label),
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 20,
                                                    bottom: 20,
                                                    right: 10),
                                              ),
                                            ),
                                            Container(
                                              child: CircleAvatar(
                                                child: Text(
                                                  "${(100 / snapshot.data.length).round()}%",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.blue,
                                              ),
                                              margin: EdgeInsets.only(right: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        bool isSuccessfully =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditRequirement(
                                                  requirement,
                                                  widget._specification);
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
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                    ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
