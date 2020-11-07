import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/factor/edit_factor.dart';
import 'package:perforaya/utils/alert.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditUser extends StatefulWidget {
  User _user;
  DatabaseHelper dbHelper = new DatabaseHelper();

  EditUser(this._user);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController..text = widget._user?.name;
    TextEditingController mailController = TextEditingController();
    mailController..text = widget._user?.mail;
    TextEditingController loginController = TextEditingController();
    loginController..text = widget._user?.username;
    TextEditingController passwordController = TextEditingController();
    passwordController..text = widget._user?.password;
    TextEditingController repasswordController = TextEditingController();
    repasswordController..text = widget._user?.password;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._user == null ? "Crear usuario" : "Editar usuario"),
      ),
      body: Container(
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
                  decoration: InputDecoration(labelText: "Correo electrónico"),
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
                  decoration: InputDecoration(labelText: "Confirmar contraseña"),
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
                          String password = passwordController.text.toString();
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
                          if (isValid) {
                            if (widget._user == null) {
                              widget._user = User(
                                  0,
                                  nameController.text.toString(),
                                  mailController.text.toString(),
                                  loginController.text.toString(),
                                  passwordController.text.toString());
                            } else {
                              widget._user.name =
                                  nameController.text.toString();
                              widget._user.mail =
                                  mailController.text.toString();
                              widget._user.username =
                                  loginController.text.toString();
                              widget._user.password =
                                  passwordController.text.toString();
                            }
                            var db = await widget.dbHelper.database;
                            await User.save(db, widget._user);
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
    );
  }


}
