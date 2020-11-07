import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/requirements/requirements_by_equipment_dialog.dart';
import 'package:perforaya/utils/database_helper.dart';

class SpecificationsByEquipment extends StatefulWidget {
  int _project;
  int _factor;
  int _system;
  int _equipment;

  SpecificationsByEquipment(this._project, this._factor, this._system, this._equipment);

  @override
  _SpecificationsByEquipmentState createState() => _SpecificationsByEquipmentState();
}

class _SpecificationsByEquipmentState extends State<SpecificationsByEquipment> {
  DatabaseHelper dbHelper = new DatabaseHelper();
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          style: TextStyle(
            //backgroundColor: Colors.white,
              color: Colors.white),
        )
            : Text("Especificaciones"),
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
        ],
      ),
      body: FutureBuilder<List<Specification>>(
        future: Specification.listByProjectFactorSystemAndEquipmentHelper(dbHelper, widget._project, widget._factor, widget._system, widget._equipment),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              Specification specification = snapshot.data[i];
              return ListTile(
                title: Text(specification.name),
                onTap: () async{
                  var db = await dbHelper.database;
                  var theEquipment = await Equipment.getById(db, widget._equipment);
                  var listByProjectFactorSystemEquipmentAndSpecification = await Requirement.listByProjectFactorSystemEquipmentAndSpecification(db, widget._project, widget._factor, widget._system, widget._equipment, specification.id);

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: RequirementsByEquipmentDialog(theEquipment, listByProjectFactorSystemEquipmentAndSpecification),
                        );
                      }).then((value) {
                    setState(() {});
                  });
                },
              );
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
