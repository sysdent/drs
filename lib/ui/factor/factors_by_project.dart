import 'package:flutter/material.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/ui/system/systems_by_factor.dart';
import 'package:perforaya/utils/database_helper.dart';

class FactorsByProject extends StatefulWidget {
  int _project;

  FactorsByProject(this._project);

  @override
  _FactorsByProjectState createState() => _FactorsByProjectState();
}

class _FactorsByProjectState extends State<FactorsByProject> {
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
            : Text("Factores"),
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
      body: FutureBuilder<List<Factor>>(
        future: Factor.listByProjectHelper(dbHelper, widget._project),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Factor factor = snapshot.data[i];
                    return ListTile(
                      title: Text(factor.name),
                      onTap: () async{
                        bool isSuccessfully = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              //return EditProject(null);
                              return SystemsByFactor(widget._project, factor.id);
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
