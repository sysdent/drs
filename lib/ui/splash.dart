import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/login.dart';
import 'package:perforaya/ui/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPY extends StatefulWidget {
  @override
  _SplashScreenPYState createState() => _SplashScreenPYState();
}

class _SplashScreenPYState extends State<SplashScreenPY> {
  @override
  void initState() {
    super.initState();
    Widget nextScreen = LoginScreen();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((prefs) {
      var id = prefs.getInt("id");
      if (id != null) {
        var name = prefs.getString("name");
        var mail = prefs.getString("mail");
        var login = prefs.getString("login");
        var passw = prefs.getString("passw");
        nextScreen = MainScreen(0, User(id, name, mail, login, passw));
      }
    });

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => nextScreen)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/splash.png"),
          ),
        ],
      ),
    );
  }
}
