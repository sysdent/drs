import 'package:flutter/material.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/requirement_value.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/utils/database_helper.dart';

class RequirementsDialog extends StatefulWidget {
  Offer _offer;
  System system;
  Equipment equipment;
  Specification specification;
  Iterable<Requirement> requirements;
  Iterable<RequirementValue> rqValues;
  int factorType;
  DatabaseHelper dbHelper = new DatabaseHelper();

  RequirementsDialog(this._offer, this.system, this.equipment,
      this.specification, this.requirements, this.factorType, this.rqValues);

  @override
  _RequirementsDialogState createState() => _RequirementsDialogState();
}

class _RequirementsDialogState extends State<RequirementsDialog> {
  int _currentStep = 0;

  Map<String, int> percents = new Map();
  Map<String, TextEditingController> controllers = new Map();

  List<Widget> createSteps() {
    List<Widget> steps = [];
    steps.add(
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          widget.equipment.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );

    widget.requirements.forEach((rq) {
      var rqValues4Requirement = widget.rqValues
          .where((element) =>
              element.project == rq.project &&
              element.factor == rq.factor &&
              element.system == rq.system &&
              element.equipment == rq.equipment &&
              element.specification == rq.specification &&
              element.requirement == rq.id &&
              element.offer == widget._offer.id
      )
          .toList();

      String controllerPercentKey =
          "${widget.factorType}_percent_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
      percents.putIfAbsent(
          controllerPercentKey,
          () => rqValues4Requirement.length > 0
              ? rqValues4Requirement[0].value
              : 0);

      String controllerCommentKey =
          "${widget.factorType}_comment_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
      controllers.putIfAbsent(
          controllerCommentKey,
          () => TextEditingController(
              text: rqValues4Requirement.length > 0
                  ? rqValues4Requirement[0].comment
                  : ''));

      String economicValueKey =
          "${widget.factorType}_value_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
      controllers.putIfAbsent(
          economicValueKey,
          () => TextEditingController(
              text: rqValues4Requirement.length > 0
                  ? rqValues4Requirement[0].value.toString()
                  : ''));

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
                Text(
                  rq.expected,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                  softWrap: true,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.factorType == ECONOMIC
                        ? TextField(
                            decoration: InputDecoration(labelText: "Valor"),
                            keyboardType: TextInputType.number,
                            controller: controllers[economicValueKey],
                          )
                        : Row(
                            children: [
                              Slider(
                                min: 0,
                                max: 100,
                                value: percents[controllerPercentKey] + .0,
                                onChanged: (val) {
                                  setState(() {
                                    percents[controllerPercentKey] = val.ceil();
                                    print("${percents[controllerPercentKey]}");
                                  });
                                },
                              ),
                              Text("${percents[controllerPercentKey]}%"),
                            ],
                          ),
                    TextField(
                      maxLines: 2,
                      decoration: InputDecoration(labelText: "Comentario"),
                      controller: controllers[controllerCommentKey],
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
                    String controllerPercentKey =
                        "${widget.factorType}_percent_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
                    String controllerCommentKey =
                        "${widget.factorType}_comment_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";
                    String economicValueKey =
                        "${widget.factorType}_value_${widget._offer.project}_${rq.factor}_${rq.system}_${rq.equipment}_${rq.specification}_${rq.id}";

                    var percent = percents[controllerPercentKey];
                    var comment =
                        controllers[controllerCommentKey].text.toString();
                    var economicValue =
                        controllers[economicValueKey].text.toString();
                    if (percent != null || comment != null) {
                      var dbRqValue = await RequirementValue
                          .getByProjectFactorSystemEquipmentSpecificationOfferAndRequirement(
                              db,
                              rq.project,
                              rq.factor,
                              rq.system,
                              rq.equipment,
                              rq.specification,
                              widget._offer.id,
                              rq.id);
                      if (dbRqValue == null) {
                        dbRqValue = RequirementValue(
                            0,
                            rq.project,
                            rq.factor,
                            rq.system,
                            rq.equipment,
                            rq.specification,
                            rq.id,
                            widget._offer.id,
                            widget.factorType == ECONOMIC ? int.parse(economicValue.isEmpty ? "0" : economicValue) : percent,
                            comment);
                      } else {
                        dbRqValue.value = widget.factorType == ECONOMIC ? int.parse(economicValue.isEmpty ? "0" : economicValue) : percent;
                        dbRqValue.comment = comment;
                      }
                      RequirementValue.save(db, dbRqValue);
                    }
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
