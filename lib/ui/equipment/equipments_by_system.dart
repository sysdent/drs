import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/specification/specifications_by_equipment.dart';
import 'package:perforaya/utils/database_helper.dart';

class EquipmentsBySystem extends StatefulWidget {
  int _project;
  int _factor;
  int _system;

  EquipmentsBySystem(this._project, this._factor, this._system);

  @override
  _EquipmentsBySystemState createState() => _EquipmentsBySystemState();
}

class _EquipmentsBySystemState extends State<EquipmentsBySystem> {
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
            : Text("Equipos"),
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
      body: FutureBuilder<List<Equipment>>(
        future: Equipment.listByProjectFactorAndSystemHelper(
            dbHelper, widget._project, widget._factor, widget._system),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Equipment equipment = snapshot.data[i];
                    return ListTile(
                      title: Text(equipment.name),
                      onTap: () async {
                        bool isSuccessfully = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              //return EditProject(null);
                              return SpecificationsByEquipment(widget._project,
                                  widget._factor, widget._system, equipment.id);
                            },
                          ),
                        );
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
