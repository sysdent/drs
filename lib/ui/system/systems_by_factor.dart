import 'package:flutter/material.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/equipment/equipments_by_system.dart';
import 'package:perforaya/utils/database_helper.dart';

class SystemsByFactor extends StatefulWidget {
  int _project;
  int _factor;

  SystemsByFactor(this._project, this._factor);

  @override
  _SystemsByFactorState createState() => _SystemsByFactorState();
}

class _SystemsByFactorState extends State<SystemsByFactor> {
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
            : Text("Sistemas"),
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
      body: FutureBuilder<List<System>>(
        future: System.listByProjectHelper(dbHelper, widget._project, widget._factor),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              System system = snapshot.data[i];
              return ListTile(
                title: Text(system.name),
                onTap: () async{
                  bool isSuccessfully = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        //return EditProject(null);
                        return EquipmentsBySystem(widget._project, widget._factor, system.id);
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
