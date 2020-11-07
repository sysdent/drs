import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perforaya/contants.dart';
import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/fx/Equipment_fx.dart';
import 'package:perforaya/model/fx/factor_fx.dart';
import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/offer_fx.dart';
import 'package:perforaya/model/fx/requirement_fx.dart';
import 'package:perforaya/model/fx/specification_fx.dart';
import 'package:perforaya/model/fx/system_fx.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/requirement_value.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/ui/offer/offer_report.dart';
import 'package:perforaya/ui/offer/requirements_dialog.dart';
import 'package:perforaya/utils/database_helper.dart';

class EditOffer extends StatefulWidget {
  Offer _offer;
  DatabaseHelper dbHelper = new DatabaseHelper();
  List<Project> projects;
  int _currentProject = 0;
  Map<String, int> percents = new Map();
  Map<String, TextEditingController> controllers = new Map();

  EditOffer(this.projects, this._offer);

  @override
  _EditOfferState createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  int _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    widget._currentProject = this.widget._offer?.project;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(this.widget._offer == null ? "Crear oferta" : "Editar oferta"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
            ),
            onPressed: () async {
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
                              Text("Calculando...")
                            ],
                          ),
                        ),
                      ),
                    );
                  });

              var db = await widget.dbHelper.database;

              OfferFx offerFx =
                  OfferFx(widget._offer.id, widget._offer.company, 100, "");
              var factors =
                  await Factor.listByProject(db, widget._offer.project);

              for (var factor in factors) {
                if (factor.type == ECONOMIC) {
                  continue;
                }
                var factorFx =
                    FactorFx(factor.id, factor.name, factor.weight, "");
                offerFx.addChild(factorFx);
                var systems = await System.listByFactorAndProject(
                    db, widget._offer.project, factor.id);
                for (var system in systems) {
                  var systemFx =
                      SystemFx(system.id, system.name, system.weight, "");
                  factorFx.addChild(systemFx);
                  var equipments = await Equipment.listByProjectFactorAndSystem(
                      db, widget._offer.project, factor.id, system.id);
                  for (var equipment in equipments) {
                    if(equipment.state != 1){
                      continue;
                    }
                    var equipmentFx = EquipmentFx(
                        equipment.id, equipment.name, equipment.weight, "");
                    systemFx.addChild(equipmentFx);
                    var specifications = await Specification
                        .listByProjectFactorSystemAndEquipment(
                            db,
                            widget._offer.project,
                            factor.id,
                            system.id,
                            equipment.id);
                    for (var specification in specifications) {
                      var specificationFx = SpecificationFx(specification.id,
                          specification.name, specification.weight, "");
                      equipmentFx.addChild(specificationFx);
                      var requirements = await Requirement
                          .listByProjectFactorSystemEquipmentAndSpecification(
                              db,
                              widget._offer.project,
                              factor.id,
                              system.id,
                              equipment.id,
                              specification.id);
                      for (var requirement in requirements) {
                        if (requirement.state == 1) {
                          var requirementFx = RequirementFx(
                              requirement.id, requirement.label, 0, "");
                          var rqValue = await RequirementValue
                              .getByProjectFactorSystemEquipmentSpecificationOfferAndRequirement(
                                  db,
                                  widget._offer.project,
                                  factor.id,
                                  system.id,
                                  equipment.id,
                                  specification.id,
                                  widget._offer.id,
                                  requirement.id);
                          if (rqValue != null) {
                            requirementFx.setValue(rqValue.value + .0);
                            requirementFx.comment = rqValue.comment;
                          }
                          specificationFx.addChild(requirementFx);
                        }
                      }
                      specificationFx.computeValue();
                    }
                    equipmentFx.computeValue();
                  }
                  systemFx.computeValue();
                }
                factorFx.computeValue();
              }
              offerFx.computeValue();
              offerFx.printFx();
              Navigator.pop(context);
              widget._offer.score = offerFx.value;
              Offer.save(db, widget._offer);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OfferReport(widget._offer, offerFx.toList(), 1);
              }));
              //var rqValues = await RequirementValue.listByProject(db, widget._offer.project);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getDbItems(),
        builder:
            (context, AsyncSnapshot<Map<String, List<EntityModel>>> snapshot) {
          return getScreen(snapshot);
        },
      ),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Future<Map<String, List<EntityModel>>> getDbItems() async {
    var db = await widget.dbHelper.database;
    Map<String, List<EntityModel>> lists = Map<String, List<EntityModel>>();
    if (widget._offer != null) {
      List<Factor> theFactors =
          await Factor.listByProject(db, widget._offer.project);
      List<System> systems =
          await System.listByProject(db, widget._offer.project);
      List<Equipment> equipments =
          await Equipment.listByProjectAndState(db, widget._offer.project, 1);
      List<Specification> specifications =
          await Specification.listByProject(db, widget._offer.project);
      List<Requirement> requirements =
          await Requirement.listByProjectActive(db, widget._offer.project);
      List<RequirementValue> rqValues =
          await RequirementValue.listByOffer(db, widget._offer.id);

      lists.putIfAbsent("factors", () => theFactors);
      lists.putIfAbsent("systems", () => systems);
      lists.putIfAbsent("equipments", () => equipments);
      lists.putIfAbsent("specifications", () => specifications);
      lists.putIfAbsent("requirements", () => requirements);
      lists.putIfAbsent("rqValues", () => rqValues);
    }
    return lists;
  }

  BottomNavigationBar getBottomNavigationBar() {
    if (widget._offer == null) {
      return null;
    }
    return BottomNavigationBar(
      currentIndex: _currentScreen,
      type: BottomNavigationBarType.fixed,
      items: getTabs(),
      onTap: (index) {
        setState(() {
          _currentScreen = index;
        });
      },
    );
  }

  List<BottomNavigationBarItem> getTabs() {
    var tabs = [
      BottomNavigationBarItem(
        icon: Icon(Icons.info),
        title: Text(""),
      ),
    ];
    if (widget._offer != null) {
      tabs.add(BottomNavigationBarItem(
        icon: Icon(Icons.build),
        title: Text(""),
      ));
      tabs.add(BottomNavigationBarItem(
        icon: Icon(Icons.local_florist),
        title: Text(""),
      ));
      tabs.add(BottomNavigationBarItem(
        icon: Icon(Icons.event),
        title: Text(""),
      ));
      tabs.add(BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        title: Text(""),
      ));
    }
    return tabs;
  }

  Widget getScreen(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (_currentScreen == 0) {
      return getInfo();
    }
    if (_currentScreen == 1) {
      return getTechnical(snapshot);
    }
    if (_currentScreen == 2) {
      return getEnvironmental(snapshot);
    }
    if (_currentScreen == 3) {
      return getLogistic(snapshot);
    }
    if (_currentScreen == 4) {
      return getEconomic(snapshot);
    }
    return getInfo();
  }

  Widget getInfo() {
    TextEditingController companyController = TextEditingController();
    companyController..text = widget._offer?.company ?? '';
    TextEditingController drillNameController = TextEditingController();
    drillNameController..text = widget._offer?.drillName ?? '';
    TextEditingController statusController = TextEditingController();
    statusController..text = widget._offer?.currentStatus ?? '';
    TextEditingController dateController = TextEditingController();
    dateController
      ..text = widget._offer?.date == null ? '' : widget._offer.date.toString();
    TextEditingController locationController = TextEditingController();
    locationController..text = widget._offer?.location ?? '';
    TextEditingController lastWorkDateController = TextEditingController();
    lastWorkDateController
      ..text = widget._offer?.dateLastWork == null
          ? ''
          : widget._offer.dateLastWork.toString();
    TextEditingController powerController = TextEditingController();
    powerController
      ..text =
          widget._offer?.power == null ? '' : widget._offer?.power.toString();
    TextEditingController maxLoadController = TextEditingController();
    maxLoadController
      ..text = widget._offer?.maxLoad == null
          ? ''
          : widget._offer.maxLoad.toString();
    TextEditingController ratedCapacityController = TextEditingController();
    ratedCapacityController
      ..text = widget._offer?.ratedCapacity == null
          ? ''
          : widget._offer.ratedCapacity.toString();
    TextEditingController yearController = TextEditingController();
    yearController
      ..text = widget._offer?.year == null ? '' : widget._offer.year.toString();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(2.0),
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(2.0),
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Información de la oferta",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                DropdownButtonFormField(
                  value: this.widget._offer?.project,
                  decoration: InputDecoration(labelText: "Proyecto"),
                  items: this
                      .widget
                      .projects
                      .map<DropdownMenuItem<int>>((Project project) {
                    return DropdownMenuItem<int>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    widget._currentProject = newValue;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Nombre del taladro"),
                  controller: drillNameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Estado actual"),
                  controller: statusController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Compañía"),
                  controller: companyController,
                ),
                //Tipo de taladro
                TextField(
                  decoration: InputDecoration(labelText: "Año de construcción"),
                  controller: yearController,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "Fecha de disponibilidad"),
                  controller: dateController,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Localización actual"),
                  controller: locationController,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "Último trabajo realizado"),
                  controller: lastWorkDateController,
                  keyboardType: TextInputType.number,
                ),
                //Area de trabajo del taladro.


                TextField(
                  decoration: InputDecoration(labelText: "Potencia total"),
                  controller: powerController,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Máxima potencia"),
                  controller: maxLoadController,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Máxima profundidad del pozo"),
                  controller: ratedCapacityController,
                  keyboardType: TextInputType.number,
                ),

                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text("Guardar"),
                        onPressed: () async {
                          if (this.widget._offer == null) {
                            this.widget._offer = Offer(
                                0,
                                widget._currentProject,
                                companyController.text.toString(),
                                drillNameController.text.toString(),
                                statusController.text.toString(),
                                int.parse(dateController.text.toString()),
                                locationController.text.toString(),
                                int.parse(
                                    lastWorkDateController.text.toString()),
                                double.parse(powerController.text.toString()),
                                int.parse(maxLoadController.text.toString()),
                                int.parse(
                                    ratedCapacityController.text.toString()),
                                int.parse(yearController.text.toString()));
                          } else {
                            this.widget._offer.project = widget._currentProject;
                            this.widget._offer.company =
                                companyController.text.toString();
                            this.widget._offer.drillName =
                                drillNameController.text.toString();
                            this.widget._offer.currentStatus =
                                statusController.text.toString();
                            this.widget._offer.date =
                                int.parse(dateController.text.toString());
                            this.widget._offer.location =
                                locationController.text.toString();
                            this.widget._offer.dateLastWork = int.parse(
                                lastWorkDateController.text.toString());
                            this.widget._offer.power =
                                double.parse(powerController.text.toString());
                            this.widget._offer.maxLoad =
                                int.parse(maxLoadController.text.toString());
                            this.widget._offer.ratedCapacity = int.parse(
                                ratedCapacityController.text.toString());
                            this.widget._offer.year =
                                int.parse(yearController.text.toString());
                          }
                          var db = await widget.dbHelper.database;
                          await Offer.save(db, this.widget._offer);
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
            ),
          ),
        ),
      ),
    );
  }

  Widget getTechnical(AsyncSnapshot<Map<String, List<EntityModel>>> snapshot) {
    List<Factor> factors = snapshot.data['factors'];
    List<System> systems = snapshot.data['systems'];
    List<Equipment> equipments = snapshot.data['equipments'];
    List<Requirement> requirements = snapshot.data['requirements'];
    List<RequirementValue> rqValues = snapshot.data['rqValues'];
    List<Specification> specifications = snapshot.data['specifications'];

    var technicalId =
        factors.where((factor) => factor.type == TECHNICAL).toList()[0].id;

    int index = 1;
    List<ListTile> items = [];
    systems.where((system) => system.factor == technicalId).forEach((system) {
      equipments
          .where((equipment) =>
              equipment.system == system.id && equipment.factor == technicalId)
          .forEach((equipment) {
        String equipmentName =
            equipment.name.substring(equipment.name.indexOf('.') + 1).trim();

        Iterable<Specification> specificationsByEquipment =
            specifications.where((specification) =>
                specification.equipment == equipment.id &&
                specification.system == system.id &&
                specification.factor == technicalId);
        specificationsByEquipment.forEach((specification) {
          Iterable<Requirement> requirementsBySpecification =
              requirements.where((requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == technicalId);

          Iterable<RequirementValue> rqValuesBySpecification = rqValues.where(
              (requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == technicalId);

          items.add(
            ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: requirementsBySpecification.length ==
                          rqValuesBySpecification.length
                      ? Colors.green
                      : Colors.blue,
                  child: Text(index.toString()),
                ),
              ),
              title: Text(equipmentName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(system.name),
                  if (equipment.allowsp == 1) Text(specification.name),
                ],
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: getRequirementsDialog(
                              system,
                              equipment,
                              specification,
                              requirements,
                              rqValues,
                              technicalId,
                              TECHNICAL)
                          //Text("${equipmentName}"),
                          );
                    }).then((value) {
                  setState(() {});
                });
              },
            ),
          );
          index++;
        });
      });
    });

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: items,
      ),
    );
  }

  Widget getEnvironmental(
      AsyncSnapshot<Map<String, List<EntityModel>>> snapshot) {
    List<Factor> factors = snapshot.data['factors'];
    List<System> systems = snapshot.data['systems'];
    List<Equipment> equipments = snapshot.data['equipments'];
    List<Requirement> requirements = snapshot.data['requirements'];
    List<RequirementValue> rqValues = snapshot.data['rqValues'];
    List<Specification> specifications = snapshot.data['specifications'];

    var environmentalId =
        factors.where((factor) => factor.type == ENVIRONMENTAL).toList()[0].id;

    int index = 1;
    List<ListTile> items = [];
    systems
        .where((element) => element.factor == environmentalId)
        .forEach((system) {
      equipments
          .where((equipment) =>
              equipment.system == system.id &&
              equipment.factor == environmentalId)
          .forEach((equipment) {
        String equipmentName =
            equipment.name.substring(equipment.name.indexOf('.') + 1).trim();

        Iterable<Specification> specificationsByEquipment =
            specifications.where((specification) =>
                specification.equipment == equipment.id &&
                specification.system == system.id &&
                specification.factor == environmentalId);
        specificationsByEquipment.forEach((specification) {
          Iterable<Requirement> requirementsBySpecification =
              requirements.where((requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == environmentalId);

          Iterable<RequirementValue> rqValuesBySpecification = rqValues.where(
              (requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == environmentalId);

          items.add(
            ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: requirementsBySpecification.length ==
                          rqValuesBySpecification.length
                      ? Colors.green
                      : Colors.blue,
                  child: Text(index.toString()),
                ),
              ),
              title: Text(equipmentName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$SYSTEM: ${system.name}"),
                  Text(specification.name),
                ],
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: getRequirementsDialog(
                              system,
                              equipment,
                              specification,
                              requirements,
                              rqValues,
                              environmentalId,
                              ENVIRONMENTAL)
                          //Text("${equipmentName}"),
                          );
                    }).then((value) {
                  setState(() {});
                });
              },
            ),
          );
          index++;
        });
      });
    });

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: items,
      ),
    );
  }

  Widget getEconomic(AsyncSnapshot<Map<String, List<EntityModel>>> snapshot) {
    List<Factor> factors = snapshot.data['factors'];
    List<System> systems = snapshot.data['systems'];
    List<Equipment> equipments = snapshot.data['equipments'];
    List<Requirement> requirements = snapshot.data['requirements'];
    List<RequirementValue> rqValues = snapshot.data['rqValues'];
    List<Specification> specifications = snapshot.data['specifications'];

    var economicId =
        factors.where((factor) => factor.type == ECONOMIC).toList()[0].id;

    int index = 1;
    List<ListTile> items = [];
    systems.where((element) => element.factor == economicId).forEach((system) {
      equipments
          .where((equipment) =>
              equipment.system == system.id && equipment.factor == economicId)
          .forEach((equipment) {
        String equipmentName =
            equipment.name.substring(equipment.name.indexOf('.') + 1).trim();

        Iterable<Specification> specificationsByEquipment =
            specifications.where((specification) =>
                specification.equipment == equipment.id &&
                specification.system == system.id &&
                specification.factor == economicId);
        specificationsByEquipment.forEach((specification) {
          Iterable<Requirement> requirementsBySpecification =
              requirements.where((requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == economicId);

          Iterable<RequirementValue> rqValuesBySpecification = rqValues.where(
              (requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == economicId);

          items.add(
            ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: requirementsBySpecification.length ==
                          rqValuesBySpecification.length
                      ? Colors.green
                      : Colors.blue,
                  child: Text(index.toString()),
                ),
              ),
              title: Text(equipmentName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(system.name),
                  if (equipment.allowsp == 1) Text(specification.name),
                ],
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: getRequirementsDialog(system, equipment,
                              specification, requirements, rqValues, economicId, ECONOMIC)
                          //Text("${equipmentName}"),
                          );
                    }).then((value) {
                  setState(() {});
                });
              },
            ),
          );
          index++;
        });
      });
    });

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: items,
      ),
    );
  }

  Widget getLogistic(AsyncSnapshot<Map<String, List<EntityModel>>> snapshot) {
    List<Factor> factors = snapshot.data['factors'];
    List<System> systems = snapshot.data['systems'];
    List<Equipment> equipments = snapshot.data['equipments'];
    List<Requirement> requirements = snapshot.data['requirements'];
    List<RequirementValue> rqValues = snapshot.data['rqValues'];
    List<Specification> specifications = snapshot.data['specifications'];

    var logisticId =
        factors.where((factor) => factor.type == LOGISTIC).toList()[0].id;

    int index = 1;
    List<ListTile> items = [];
    systems.where((element) => element.factor == logisticId).forEach((system) {
      equipments
          .where((equipment) =>
              equipment.system == system.id && equipment.factor == logisticId)
          .forEach((equipment) {
        String equipmentName =
            equipment.name.substring(equipment.name.indexOf('.') + 1).trim();

        Iterable<Specification> specificationsByEquipment =
            specifications.where((specification) =>
                specification.equipment == equipment.id &&
                specification.system == system.id &&
                specification.factor == logisticId);
        specificationsByEquipment.forEach((specification) {
          Iterable<Requirement> requirementsBySpecification =
              requirements.where((requirement) =>
                  requirement.state == 1 &&
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == logisticId);

          Iterable<RequirementValue> rqValuesBySpecification = rqValues.where(
              (requirement) =>
                  requirement.specification == specification.id &&
                  requirement.equipment == equipment.id &&
                  requirement.system == system.id &&
                  requirement.factor == logisticId);

          items.add(
            ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: requirementsBySpecification.length ==
                          rqValuesBySpecification.length
                      ? Colors.green
                      : Colors.blue,
                  child: Text(index.toString()),
                ),
              ),
              title: Text(equipmentName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(system.name),
                  if (equipment.allowsp == 1) Text(specification.name),
                ],
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: getRequirementsDialog(system, equipment,
                              specification, requirements, rqValues, logisticId, LOGISTIC)
                          //Text("${equipmentName}"),
                          );
                    }).then((value) {
                  setState(() {});
                });
              },
            ),
          );
          index++;
        });
      });
    });

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: items,
      ),
    );
  }

  Widget getRequirementsDialog(
      System system,
      Equipment equipment,
      Specification specification,
      List<Requirement> requirements,
      List<RequirementValue> rqValues,
      int favtoId,
      int factorType) {
    Iterable<Requirement> requirementsBySpecification = requirements.where(
        (requirement) =>
            requirement.specification == specification.id &&
            requirement.equipment == equipment.id &&
            requirement.system == system.id &&
            requirement.factor == favtoId);

    return RequirementsDialog(widget._offer, system, equipment, specification,
        requirementsBySpecification, factorType, rqValues);
  }
}
