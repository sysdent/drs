import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/factor/edit_factor.dart';
import 'package:perforaya/utils/alert.dart';
import 'package:perforaya/utils/database_helper.dart';

class RegisterUser extends StatefulWidget {
  DatabaseHelper dbHelper = new DatabaseHelper();

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController mailController = TextEditingController();
    TextEditingController loginController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController repasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de nuevo usuario"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(2.0),
          child: Card(
            elevation: 2.0,
            margin: EdgeInsets.all(2.0),
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Nombre"),
                    controller: nameController,
                    keyboardType: TextInputType.name,
                  ),
                  TextField(
                    decoration:
                        InputDecoration(labelText: "Correo electrónico"),
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Usuario"),
                    controller: loginController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Contraseña"),
                    controller: passwordController,
                    obscureText: true,
                  ),
                  TextField(
                    decoration:
                        InputDecoration(labelText: "Confirmar contraseña"),
                    controller: repasswordController,
                    obscureText: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text("Guardar"),
                          onPressed: () async {
                            String name = nameController.text.toString();
                            String mail = mailController.text.toString();
                            String login = loginController.text.toString();
                            String password =
                                passwordController.text.toString();
                            String repassword =
                                repasswordController.text.toString();
                            bool isValid = true;
                            if (name.isEmpty) {
                              alert(context, "Error de validación de datos",
                                  "El campo nombre es obligatorio");
                              isValid = false;
                            }
                            if (isValid && mail.isEmpty) {
                              alert(context, "Error de validación de datos",
                                  "El campo correo electrónico es obligatorio");
                              isValid = false;
                            }
                            if (isValid && login.isEmpty) {
                              alert(context, "Error de validación de datos",
                                  "El campo usuario es obligatorio");
                              isValid = false;
                            }
                            if (isValid && password.isEmpty) {
                              alert(context, "Error de validación de datos",
                                  "El campo contraseña es obligatorio");
                              isValid = false;
                            }
                            if (isValid && repassword.isEmpty) {
                              alert(context, "Error de validación de datos",
                                  "El campo confirmación de la contraseña es obligatorio");
                              isValid = false;
                            }
                            if (isValid && repassword != password) {
                              alert(context, "Error de validación de datos",
                                  "La contraseña y su confirmación no son iguales.");
                              isValid = false;
                            }

                            var currentUser = await User.getByUsernameHelper(widget.dbHelper, login);
                            if(currentUser != null){
                              alert(context, "Error de validación de datos",
                                  "El nombre de usuario no está disponible.");
                              isValid = false;
                            }

                            if (isValid) {
                              var _user = User(
                                  0,
                                  nameController.text.toString(),
                                  mailController.text.toString(),
                                  loginController.text.toString(),
                                  passwordController.text.toString());
                              var db = await widget.dbHelper.database;
                              await User.save(db, _user);
                              Navigator.pop(context, true);
                            }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
