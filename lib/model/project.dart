import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'project';
const COLUMN_ID = 'id';
const COLUMN_NAME = 'name';
const COLUMN_WELLNAME = 'wellname';
const COLUMN_LOCATION = 'location';
const COLUMN_AREA = 'area';
const COLUMN_DEPTH = 'depth';
const COLUMN_COMPANY = 'company';
const COLUMN_STARTDATE = 'startdate';
const COLUMN_USER = 'owuser';

class Project extends EntityModel {
  String _name;
  String _wellname;
  String _location;
  String _area;
  String _depth;
  String _company;
  String _startdate;
  int _user;

  Project(int id, this._name) : super(id);

  set name(String name) {
    this._name = name;
  }

  set wellname(String wellname) {
    this._wellname = wellname;
  }

  set location(String location) {
    this._location = location;
  }

  set area(String area) {
    this._area = area;
  }

  set depth(String depth) {
    this._depth = depth;
  }

  set company(String company) {
    this._company = company;
  }

  set startdate(String startdate) {
    this._startdate = startdate;
  }

  set user(int user) {
    this._user = user;
  }

  String get name => this._name;
  String get wellname => this._wellname;
  String get location => this._location;
  String get area => this._area;
  String get depth => this._depth;
  String get company => this._company;
  String get startdate => this._startdate;
  int get user => this._user;

  static Project fromMap(Map<String, dynamic> map) {
    var project = Project(map[COLUMN_ID], map[COLUMN_NAME]);
    project.wellname = map[COLUMN_WELLNAME];
    project.location = map[COLUMN_LOCATION];
    project.area = map[COLUMN_AREA];
    project.depth = map[COLUMN_DEPTH];
    project.company = map[COLUMN_COMPANY];
    project.startdate = map[COLUMN_STARTDATE];
    project.user = map[COLUMN_USER];
    return project;
  }

  static Map<String, dynamic> toMap(Project project) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = project.id;
    map[COLUMN_NAME] = project.name;
    map[COLUMN_WELLNAME] = project.wellname;
    map[COLUMN_LOCATION] = project.location;
    map[COLUMN_AREA] = project.area;
    map[COLUMN_DEPTH] = project.depth;
    map[COLUMN_COMPANY] = project.company;
    map[COLUMN_STARTDATE] = project.startdate;
    map[COLUMN_USER] = project.user;
    return map;
  }

  static Future<List<Project>> list(Database db, String nameFilter) async {
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC');
    List<Project> projectList = new List<Project>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      projectList.add(Project.fromMap(result[i]));
    }
    return projectList;
  }

  static Future<List<Project>> listProjects(Database db, String nameFilter, int user) async {
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC' , where: '$COLUMN_USER = ?', whereArgs: [user]);
    List<Project> projectList = new List<Project>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      projectList.add(Project.fromMap(result[i]));
    }
    return projectList;
  }

  static Future<int> save(Database db, Project project) async {
    if (project.id <= 0) {
      project.id = null;
      var newId = await db.insert(TABLE_NAME, Project.toMap(project));
      var factors = await Factor.listByProject(db, 1);

      factors.forEach((factor) async {
        var tplFactor = factor.id;
        factor.id = 0;
        factor.project = newId;
        var newFactorId = await Factor.save(db, factor);
        var systems = await System.listByFactorAndProject(db, 1, tplFactor);
        systems.forEach((system) async {
          var tplSystem = system.id;
          system.id = 0;
          system.project = newId;
          system.factor = newFactorId;
          var newSystemId = await System.save(db, system);
          var equipments = await Equipment.listByProjectFactorAndSystem(
              db, 1, tplFactor, tplSystem);
          equipments.forEach((equipment) async {
            var tplEquipment = equipment.id;
            equipment.id = 0;
            equipment.project = newId;
            equipment.factor = newFactorId;
            equipment.system = newSystemId;
            var newEquipmentId = await Equipment.save(db, equipment);
            var specifications =
                await Specification.listByProjectFactorSystemAndEquipment(
                    db, 1, tplFactor, tplSystem, tplEquipment);
            specifications.forEach((specification) async {
              var tplSpecification = specification.id;
              specification.id = 0;
              specification.project = newId;
              specification.factor = newFactorId;
              specification.system = newSystemId;
              specification.equipment = newEquipmentId;
              var newSpecificationId =
                  await Specification.save(db, specification);
              var requirements = await Requirement
                  .listByProjectFactorSystemEquipmentAndSpecification(db, 1,
                      tplFactor, tplSystem, tplEquipment, tplSpecification);
              requirements.forEach((requirement) async {
                var tplRequirements = requirement.id;
                requirement.id = 0;
                requirement.project = newId;
                requirement.factor = newFactorId;
                requirement.system = newSystemId;
                requirement.equipment = newEquipmentId;
                requirement.specification = newSpecificationId;
                await Requirement.save(db, requirement);
              });
            });
          });
        });
      });

      return newId;
    } else {
      return db.update(TABLE_NAME, Project.toMap(project),
          where: "$COLUMN_ID = ?", whereArgs: [project.id]);
    }
  }

  static Future<int> delete(Database db, Project project) {
    if (project.id > 1) {
      Factor.deleteByProject(db, project);
      return db.delete(TABLE_NAME,
          where: " $COLUMN_ID = ?", whereArgs: [project.id]);
    }
    return null;
  }

  static getDDL() {
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_NAME TEXT, $COLUMN_WELLNAME TEXT, $COLUMN_LOCATION TEXT, $COLUMN_AREA TEXT, $COLUMN_DEPTH TEXT, $COLUMN_COMPANY TEXT, $COLUMN_STARTDATE TEXT, $COLUMN_USER INTEGER)';
  }

  static getInsert(Project project) {
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_NAME, $COLUMN_WELLNAME, $COLUMN_LOCATION, $COLUMN_AREA, $COLUMN_DEPTH, $COLUMN_COMPANY, $COLUMN_STARTDATE, $COLUMN_USER) VALUES(${project.id}, '${project.name}', '${project.wellname}', '${project.location}', '${project.area}', '${project.depth}', '${project.company}', '${project.startdate}', ${project.user});";
  }
}
