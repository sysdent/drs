import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/specification/edit_specification.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditEquipment extends StatefulWidget {
  System _system;
  Equipment _equipment;
  DatabaseHelper dbHelper = new DatabaseHelper();
  int _supportsp = -1;
  int _state = null;

  EditEquipment(this._equipment, this._system);

  @override
  _EditEquipmentState createState() => _EditEquipmentState();
}

class _EditEquipmentState extends State<EditEquipment> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController..text = this.widget._equipment?.name;
    TextEditingController weightController = TextEditingController();
    weightController..text = this.widget._equipment?.weight?.toString();

    if (widget._supportsp == -1) {
      widget._supportsp = this.widget._equipment?.allowsp;
    }
    if(widget._state == null) {
      widget._state = widget?._equipment?.state;
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.widget._equipment == null
                  ? "Crear equipo"
                  : "Editar equipo"),
              Text(
                "$SYSTEM: ${this.widget._system.name}",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        floatingActionButton: this.widget._equipment == null
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
                          return EditSpecification(null, widget._equipment);
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
                      Text("Soporta especificación?"),
                      Checkbox(
                        onChanged: (bool option) {
                          setState(() {
                            widget._supportsp = option ? 1 : 0;
                          });
                        },
                        value: widget._supportsp == 1,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Switch(
                          value: widget._state == 1,
                          onChanged: (value) {
                            setState(() {
                              widget._state = value ? 1 : 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text("Guardar"),
                          onPressed: () async {
                            if (this.widget._equipment == null) {
                              this.widget._equipment = Equipment(
                                  0,
                                  this.widget._system.project,
                                  this.widget._system.factor,
                                  this.widget._system.id,
                                  nameController.text.toString(),
                                  double.parse(
                                      weightController.text.toString()),
                                  widget._supportsp);
                            } else {
                              this.widget._equipment.project =
                                  this.widget._system.project;
                              this.widget._equipment.factor =
                                  this.widget._system.factor;
                              this.widget._equipment.system =
                                  this.widget._system.id;

                              this.widget._equipment.name =
                                  nameController.text.toString();
                              this.widget._equipment.weight = double.parse(
                                  weightController.text.toString());
                              this.widget._equipment.allowsp =
                                  widget._supportsp;
                            }
                            this.widget._equipment.state = widget._state;
                            var db = await this.widget.dbHelper.database;
                            int result = await Equipment.save(
                                db, this.widget._equipment);
                            Navigator.pop(context, true);
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
                      ),
                    ],
                  ),
                  if (widget._equipment != null)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "Especificaciones",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  if (widget._equipment != null)
                    Expanded(
                      child: FutureBuilder<List<Specification>>(
                        future: Specification
                            .listByProjectFactorSystemAndEquipmentHelper(
                                widget.dbHelper,
                                widget._equipment.project,
                                widget._equipment.factor,
                                widget._equipment.system,
                                widget._equipment.id),
                        initialData: List(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    Specification specification =
                                        snapshot.data[i];
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(specification.name),
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
                                                  "${specification.weight.round()}%",
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
                                              return EditSpecification(
                                                specification,
                                                widget._equipment,
                                              );
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
                ],
              ),
            ),
          ),
        ));
  }
}
