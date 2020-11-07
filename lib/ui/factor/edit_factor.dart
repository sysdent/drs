import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/system/edit_system.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditFactor extends StatefulWidget {
  Project _project;
  Factor _factor;
  DatabaseHelper dbHelper = new DatabaseHelper();
  int _currentType = 0;
  int total = null;

  EditFactor(this._factor, this._project);

  @override
  _EditFactorState createState() => _EditFactorState();
}

class _EditFactorState extends State<EditFactor> {
  @override
  Widget build(BuildContext context) {
    TextEditingController weightController = TextEditingController();
    weightController..text = this.widget._factor?.weight?.toString();

    if (this.widget._currentType == 0) {
      this.widget._currentType = this.widget._factor?.type;
    }

    if (widget._factor != null && widget.total == null) {
      widget.dbHelper.database.then((db) {
        System.listByProjectAndFactor(db, widget._factor.project, widget._factor.id).then((factors) {
          double totalAux = 0;
          factors.forEach((system) {
            totalAux += system.weight;
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
          Text(this.widget._factor == null ? CREATE_FACTOR : EDIT_FACTOR),
          Text(
            "Proyecto: ${widget._project.name}",
            style: TextStyle(fontSize: 10),
          ),
        ],
      )),
      floatingActionButton: this.widget._factor == null
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
                        return EditSystem(null, widget._factor);
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
                DropdownButtonFormField(
                  value: this.widget._factor?.type,
                  decoration: InputDecoration(labelText: "Tipo"),
                  items: Factor.getTypes()
                      .map<DropdownMenuItem<int>>((factorType) {
                    return DropdownMenuItem<int>(
                      value: factorType["id"],
                      child: Text(factorType["label"]),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    this.widget._currentType = newValue;
                  },
                ),
                if (this.widget?._factor?.type != ECONOMIC)
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
                          var db = await this.widget.dbHelper.database;
                          var factors = await Factor.listByProject(
                              db, this.widget._project.id);
                          if (this.widget._factor == null) {
                            this.widget._factor = Factor(
                                0,
                                this.widget._project.id,
                                Factor.getLabel(this.widget._currentType),
                                double.parse(weightController.text.toString()),
                                this.widget._currentType,
                                5);
                          } else {
                            this.widget._factor.project =
                                this.widget._project.id;
                            this.widget._factor.name =
                                Factor.getLabel(this.widget._currentType);
                            this.widget._factor.weight =
                                double.parse(weightController.text.toString());
                            this.widget._factor.type = this.widget._currentType;
                          }
                          int result =
                              await Factor.save(db, this.widget._factor);
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
                if (widget._factor != null && widget.total != 100)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "La suma de los porcentajes no es igual a 100%, por favor revisar los valores ingresados",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                if (this.widget._factor != null)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "Sistemas",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                if (this.widget._factor != null)
                  Expanded(
                    child: FutureBuilder<List<System>>(
                      future: System.listByProjectHelper(this.widget.dbHelper,
                          this.widget._factor.project, this.widget._factor.id),
                      initialData: List(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  System system = snapshot.data[i];
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Card(
                                      color: Colors.white,
                                      elevation: 2.0,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text(system.name),
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
                                                "${system.weight.round()}%",
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
                                      widget.total = null;
                                      bool isSuccessfully =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EditSystem(
                                                system, widget._factor);
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
                if (this.widget._factor != null)
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
      ),
    );
  }
}
