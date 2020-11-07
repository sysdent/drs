import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/main_screen.dart';
import 'package:perforaya/ui/user/register.dart';
import 'package:perforaya/utils/alert.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class LoginScreen extends StatelessWidget {
  DatabaseHelper dbHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    final FocusNode loginFocusNode = FocusNode();

    TextEditingController passwController = TextEditingController();
    final FocusNode paaswFocusNode = FocusNode();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 150, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/splash.png"),
                width: 200,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Inicio de sesión",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(labelText: "Usuario"),
                  controller: loginController,
                  focusNode: loginFocusNode,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controller: passwController,
                  focusNode: paaswFocusNode,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text("Entrar"),
                  onPressed: () async {
                    String username = loginController.text.toString();
                    String password = passwController.text.toString();
                    if (username.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            backgroundColor: Colors.white,
                            actions: [
                              RaisedButton(
                                child: Text("Aceptar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .requestFocus(loginFocusNode);
                                },
                              )
                            ],
                            content: SizedBox(
                              width: 32,
                              height: 60,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Por favor indique el usuario")
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (password.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            backgroundColor: Colors.white,
                            actions: [
                              RaisedButton(
                                child: Text("Aceptar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .requestFocus(paaswFocusNode);
                                },
                              )
                            ],
                            content: SizedBox(
                              width: 32,
                              height: 60,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Por favor indique la contraseña")
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white70,
                            content: SizedBox(
                              width: 32,
                              height: 60,
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Text("Por favor espere...")
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      var dbUser = await User.getByUsernameAndPasswordHelper(
                          dbHelper, username, password);
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      if (dbUser == null) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error de inicio de sesión"),
                              backgroundColor: Colors.white,
                              actions: [
                                RaisedButton(
                                  child: Text("Aceptar"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FocusScope.of(context)
                                        .requestFocus(paaswFocusNode);
                                  },
                                )
                              ],
                              content: SizedBox(
                                width: 32,
                                height: 60,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                          "Credenciales inválidas, por favor intente nuevamente.")
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pop(context);

                        bool isSuccessfully =
                            await Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                          builder: (context) {
                            _prefs.setInt("id", dbUser.id);
                            _prefs.setString("name", dbUser.name);
                            _prefs.setString("mail", dbUser.mail);
                            _prefs.setString("login", dbUser.username);
                            _prefs.setString("passw", dbUser.password);
                            return MainScreen(0, dbUser);
                          },
                        ), (Route<dynamic> route) => false);
                      }
                    }
                  },
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Text(
                    "Olvidó su clave?",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    var login = loginController.text.toString();
                    var user = await User.getByUsernameHelper(dbHelper, login);
                    if (user == null) {
                      alert(context, "Error", "No se encontró el usuario.");
                    } else {
                      user.password = generateRandomString(8);
                      var db = await dbHelper.database;
                      User.save(db, user);
                      sendMail(context, user.password, user.mail);
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: GestureDetector(
                  child: Text(
                    "Regístrate",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    bool isSuccessfully = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterUser();
                        },
                      ),
                    );
                    if (isSuccessfully) {
                      alert(context, "Nuevo usuario",
                          "El usuario se ha registrado de forma exitosa");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void sendMail(BuildContext context, String password, String mailTo) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          content: SizedBox(
            width: 32,
            height: 60,
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text("Por favor espere...")
                ],
              ),
            ),
          ),
        );
      },
    );
    String body = '''
      Su nueva clave es <b>$password</b>
      ''';
    final smtpServer = gmail("DrillingRigSelection@gmail.com", "aplicacion123");
    final message = Message()
      ..from = Address("drillingRigSelection@gmail.com",
          'Sistema automático de envío de correos PerforaYa')
      ..recipients.add(mailTo)
      ..subject = 'Clave restaurada para ingreso a PerforaYa.'
      ..html = body;

    try {
      final sendReport = await send(message, smtpServer);
      Navigator.pop(context);
      alert(context, "Operación exitosa",
          "Sa le ha enviado un correo con su nueva clave.");
    } on MailerException catch (e) {
      Navigator.pop(context);
      String errors = "Message not sent.\n";
      for (var p in e.problems) {
        errors += '\nProblem: ${p.code}: ${p.msg}';
      }
      alert(context, "error", errors);
    }
  }
}
