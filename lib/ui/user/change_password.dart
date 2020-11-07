import 'package:flutter/material.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/utils/alert.dart';
import 'package:perforaya/utils/database_helper.dart';

class ChangePassword extends StatelessWidget {
  DatabaseHelper dbHelper = new DatabaseHelper();
  User _user;

  ChangePassword(this._user);

  @override
  Widget build(BuildContext context) {
    TextEditingController currentPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController rePassController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(2.0),
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(2.0),
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Clave actual"),
                controller: currentPassController,
                keyboardType: TextInputType.name,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Nueva clave"),
                controller: newPassController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Confirmar nueva clave"),
                controller: rePassController,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Guardar"),
                      onPressed: () async {
                        String currentPass =
                            currentPassController.text.toString();
                        String newPass = newPassController.text.toString();
                        String rePass = rePassController.text.toString();
                        bool isValid = true;
                        if (currentPass.isEmpty) {
                          alert(context, "Error de validación de datos",
                              "El campo Clave actual es obligatorio");
                          isValid = false;
                        }
                        if (isValid && newPass.isEmpty) {
                          alert(context, "Error de validación de datos",
                              "El campo Nueva clave es obligatorio");
                          isValid = false;
                        }
                        if (isValid && rePass.isEmpty) {
                          alert(context, "Error de validación de datos",
                              "El campo Confirmar nueva clave es obligatorio");
                          isValid = false;
                        }
                        if (isValid && newPass != rePass) {
                          alert(context, "Error de validación de datos",
                              "La clave y su confirmación no son iguales.");
                          isValid = false;
                        }
                        if (isValid) {
                          var currentUser = await User.getByUsernameAndPasswordHelper(this.dbHelper, _user.username, currentPass);
                          if(currentUser == null){
                            alert(context, "Error", "La clave actual no es correcta.");
                          }else{
                            this._user.password = newPass;
                            var db = await dbHelper.database;
                            await User.save(db, this._user);
                            alert(context, "Operación exitosa", "La clave se cambió con éxito.");

                            currentPassController.text = "";
                            newPassController.text = "";
                            rePassController.text = "";
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
