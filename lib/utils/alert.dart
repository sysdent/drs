import 'package:flutter/material.dart';

void alert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: Colors.white,
        actions: [
          RaisedButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        content: SizedBox(
          height: 100,
          child: Center(
            child: Column(
              children: [Text(message)],
            ),
          ),
        ),
      );
    },
  );
}

void snack(GlobalKey<ScaffoldState> _scaffoldKey, String message) {
  _scaffoldKey.currentState
      .showSnackBar(new SnackBar(content: new Text(message)));
}