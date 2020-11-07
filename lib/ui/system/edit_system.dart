import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/equipment/edit_equipment.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditSystem extends StatefulWidget {
  Factor _factor;
  System _system;
  int total = null;
  DatabaseHelper dbHelper = new DatabaseHelper();

  EditSystem(this._system, this._factor);

  @override
  _EditSystemState createState() => _EditSystemState();
}

class _EditSystemState extends State<EditSystem> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController..text = this.widget._system?.name;
    TextEditingController weightController = TextEditingController();
    weightController..text = this.widget._system?.weight?.toString();
    TextEditingController orderController = TextEditingController();
    orderController..text = this.widget._system?.order?.toString();

    if (widget._system != null  && widget.total == null) {
      widget.dbHelper.database.then((db) {
        Equipment.listByProjectFactorAndSystem(db, widget._system.project, widget._system.factor, widget._system.id).then((equipments) {
          double totalAux = 0;
          equipments.forEach((eqp) {
            totalAux += eqp.weight;
          });
          setState(() {
            widget.total = totalAux.round();
          });
        });
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.widget._system == null
                  ? "Crear sistema"
                  : "Editar sistema"),
              if (this.widget._factor.name != null)
                Text(
                  "$FACTOR: ${widget._factor.name}",
                  style: TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
        floatingActionButton: this.widget._system == null
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
                          return EditEquipment(null, widget._system);
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
                  TextField(
                    decoration: InputDecoration(labelText: "Orden"),
                    controller: orderController,
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
                            if (this.widget._system == null) {
                              this.widget._system = System(
                                  0,
                                  this.widget._factor.project,
                                  this.widget._factor.id,
                                  nameController.text.toString(),
                                  double.parse(
                                      weightController.text.toString()),
                                  int.parse(orderController.text.toString()));
                            } else {
                              this.widget._system.project =
                                  this.widget._factor.project;
                              this.widget._system.name =
                                  nameController.text.toString();
                              this.widget._system.factor =
                                  this.widget._factor.id;
                              this.widget._system.weight = double.parse(
                                  weightController.text.toString());
                              this.widget._system.order =
                                  int.parse(orderController.text.toString());
                            }
                            var db = await this.widget.dbHelper.database;
                            await System.save(db, this.widget._system);
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
                      )
                    ],
                  ),
                  if (widget._system != null && widget.total != 100)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "La suma de los porcentajes no es igual a 100%, por favor revisar los valores ingresados",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  if (widget._system != null)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "Equipos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  if (widget._system != null)
                    Expanded(
                      child: FutureBuilder<List<Equipment>>(
                        future: Equipment.listByProjectFactorAndSystemHelper(
                            widget.dbHelper,
                            widget._system.project,
                            widget._system.factor,
                            widget._system.id),
                        initialData: List(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    Equipment equipment = snapshot.data[i];
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(equipment.name),
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
                                                  "${equipment.weight.round()}%",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: equipment.state == 1 ? Colors.blue : Colors.black26,
                                              ),
                                              margin: EdgeInsets.only(right: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        widget.total = null;
                                        bool isSuccessfully =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditEquipment(
                                                  equipment, widget._system);
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
