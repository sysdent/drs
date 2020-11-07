import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/requirement_value.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/utils/database_helper.dart';

class RequirementsByEquipmentDialog extends StatefulWidget {
  Equipment _equipment;
  Iterable<Requirement> requirements;
  DatabaseHelper dbHelper = new DatabaseHelper();

  RequirementsByEquipmentDialog(this._equipment, this.requirements);

  @override
  _RequirementsByEquipmentDialogState createState() =>
      _RequirementsByEquipmentDialogState();
}

class _RequirementsByEquipmentDialogState
    extends State<RequirementsByEquipmentDialog> {
  int _currentStep = 0;

  Map<String, int> actives = new Map();
  Map<String, TextEditingController> controllers = new Map();

  List<Widget> createSteps() {
    List<Widget> steps = [];
    steps.add(
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          widget._equipment.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );

    widget.requirements.forEach((rq) {
      String controllerActiveKey =
          "active_${rq.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
      actives.putIfAbsent(controllerActiveKey, () => rq.state);

      String controllerCommentKey =
          "comment_${rq.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
      controllers.putIfAbsent(
          controllerCommentKey, () => TextEditingController(text: rq.expected));

      steps.add(
        Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rq.label,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.visible,
                  maxLines: 10,
                  softWrap: true,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLines: 2,
                      decoration: InputDecoration(labelText: "Comentario"),
                      controller: controllers[controllerCommentKey],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Switch(
                        value: actives[controllerActiveKey] == 1,
                        onChanged: (value) {
                          setState(() {
                            actives[controllerActiveKey] = value ? 1 : 0;
                          });
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
    });
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: Container(
                child: Column(children: createSteps()),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text("Guardar"),
                onPressed: () async {
                  var db = await widget.dbHelper.database;
                  widget.requirements.forEach((rq) async {
                    String controllerActiveKey =
                        "active_${rq.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
                    String controllerCommentKey =
                        "comment_${rq.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
                    var active = actives[controllerActiveKey];
                    var comment =
                        controllers[controllerCommentKey].text.toString();
                    var requirement = await Requirement.getByProjectFactorSystemEquipmentAndSpecificationHelper(db, rq.project, rq.factor, rq.system, rq.equipment, rq.specification, rq.id);
                    requirement.state = active;
                    requirement.expected = comment ?? '';
                    Requirement.save(db, requirement);
                  });
                  Navigator.pop(context, true);
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
    );
  }
}
