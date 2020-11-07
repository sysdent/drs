import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/utils/database_helper.dart';

class RequirementByEquipment extends StatefulWidget {
  int _project;
  int _factor;
  int _system;
  int _equipment;
  int _specification;

  RequirementByEquipment(this._project, this._factor, this._system,
      this._equipment, this._specification);

  @override
  _State createState() => _State();
}

class _State extends State<RequirementByEquipment> {
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
            : Text("Requerimientos"),
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
      body: FutureBuilder<List<Requirement>>(
        future: Requirement
            .listByProjectFactorSystemEquipmentAndSpecificationHelper(
          dbHelper,
          widget._project,
          widget._factor,
          widget._system,
          widget._equipment,
          widget._specification,
        ),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Requirement requirement = snapshot.data[i];
                    return ListTile(
                      title: Text(requirement.label),
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
