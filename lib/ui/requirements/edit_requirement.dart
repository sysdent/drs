import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditRequirement extends StatefulWidget {
  Specification _specification;
  Requirement _requirement;
  DatabaseHelper dbHelper = new DatabaseHelper();

  EditRequirement(this._requirement, this._specification);

  @override
  _EditRequirementState createState() => _EditRequirementState();
}

class _EditRequirementState extends State<EditRequirement> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController..text = this.widget._requirement?.label;
    TextEditingController expectedController = TextEditingController();
    expectedController..text = this.widget._requirement?.expected;
    TextEditingController commentController = TextEditingController();
    commentController..text = this.widget._requirement?.comment;
    TextEditingController weightController = TextEditingController();
    weightController..text = this.widget._requirement?.weight?.toString();

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.widget._requirement == null
                  ? "Crear requerimiento"
                  : "Editar requerimiento"),
              Text(
                "$SPECIFICATION: ${widget._specification.name}",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(2.0),
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(2.0),
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Nombre"),
                      controller: nameController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Comentario"),
                      controller: expectedController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Porcentaje"),
                      controller: weightController,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Comentario"),
                      controller: commentController,
                      maxLines: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text("Guardar"),
                            onPressed: () async {
                              if (this.widget._requirement == null) {
                                this.widget._requirement = Requirement(
                                    0,
                                    this.widget._specification.project,
                                    this.widget._specification.factor,
                                    this.widget._specification.system,
                                    this.widget._specification.equipment,
                                    this.widget._specification.id,

                                    nameController.text.toString(),
                                    expectedController.text.toString(),
                                    double.parse(
                                        weightController.text.toString()),
                                    commentController.text.toString());
                              } else {
                                this.widget._requirement.project =
                                    this.widget._specification.project;
                                this.widget._requirement.factor =
                                    this.widget._specification.factor;
                                this.widget._requirement.system =
                                    this.widget._specification.system;
                                this.widget._requirement.equipment =
                                    this.widget._specification.equipment;
                                this.widget._requirement.specification =
                                    this.widget._specification.id;

                                this.widget._requirement.label =
                                    nameController.text.toString();
                                this.widget._requirement.expected =
                                    expectedController.text.toString();
                                this.widget._requirement.weight = double.parse(
                                    weightController.text.toString());
                                this.widget._requirement.comment =
                                    commentController.text.toString();
                              }
                              var db = await this.widget.dbHelper.database;
                              await Requirement.save(
                                  db, this.widget._requirement);
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
