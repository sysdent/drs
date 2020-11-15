import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'specification';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_FACTOR = 'factor';
const COLUMN_SYSTEM = 'system';
const COLUMN_EQUIPMENT = 'equipment';
const COLUMN_NAME = 'name';
const COLUMN_WEIGHT = 'weight';

class Specification extends EntityModel {
  int _project;
  int _factor;
  int _system;
  int _equipment;
  String _equipmentName;
  String _name;
  double _weight;

  Specification(int id, this._project, this._factor, this._system,
      this._equipment, this._name, this._weight)
      : super(id);

  set project(int project) {
    this._project = project;
  }

  set factor(int factor) {
    this._factor = factor;
  }

  set system(int system) {
    this._system = system;
  }

  set equipment(int equipment) {
    this._equipment = equipment;
  }

  set name(String name) {
    this._name = name;
  }

  set weight(double weight) {
    this._weight = weight;
  }

  int get project => this._project;
  int get factor => this._factor;
  int get system => this._system;
  int get equipment => this._equipment;
  String get equipmentName => this._equipmentName;
  String get name => this._name;
  double get weight => this._weight;

  static Specification fromMap(Map<String, dynamic> map) {
    return Specification(
        map[COLUMN_ID],
        map[COLUMN_PROJECT],
        map[COLUMN_FACTOR],
        map[COLUMN_SYSTEM],
        map[COLUMN_EQUIPMENT],
        map[COLUMN_NAME],
        map[COLUMN_WEIGHT] + .0);
  }

  static Future<Specification> getById(Database db, int id) async {
    var result =
        await db.query(TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
    int count = result.length;
    if (count > 0) {
      return Specification.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Map<String, dynamic> toMap(Specification specification) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = specification.id;
    map[COLUMN_PROJECT] = specification.project;
    map[COLUMN_FACTOR] = specification.factor;
    map[COLUMN_SYSTEM] = specification.system;
    map[COLUMN_EQUIPMENT] = specification.equipment;
    map[COLUMN_NAME] = specification.name;
    map[COLUMN_WEIGHT] = specification.weight;
    return map;
  }

  static Future<List<Specification>> list(
      Database db, String nameFilter) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC');
    List<Specification> specificationList = new List<Specification>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Specification.fromMap(result[i]);
      specificationItem._equipmentName = equipments
          .firstWhere((element) => specificationItem.equipment == element.id)
          .name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Specification>> listByProject(
      Database db, int project) async {
    var result = await db.query(TABLE_NAME,
        where: "$COLUMN_PROJECT = ?",
        whereArgs: [project],
        orderBy: '$COLUMN_NAME ASC');
    List<Specification> specificationList = new List<Specification>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Specification.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Specification>> listByProjectFactorSystemAndEquipment(
      Database db, int project, int factor, int system, int equipment) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME,
        where:
            "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ?",
        whereArgs: [project, factor, system, equipment],
        orderBy: '$COLUMN_NAME ASC');
    List<Specification> specificationList = new List<Specification>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Specification.fromMap(result[i]);
      specificationItem._equipmentName = equipments
          .firstWhere((element) => specificationItem.equipment == element.id)
          .name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Specification>>
      listByProjectFactorSystemAndEquipmentHelper(DatabaseHelper dbHelper,
          int project, int factor, int system, int equipment) async {
    var db = await dbHelper.database;
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME,
        where:
            "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ?",
        whereArgs: [project, factor, system, equipment],
        orderBy: '$COLUMN_NAME ASC');
    List<Specification> specificationList = new List<Specification>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Specification.fromMap(result[i]);
      specificationItem._equipmentName = equipments
          .firstWhere((element) => specificationItem.equipment == element.id)
          .name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<int> save(Database db, Specification equipment) async{
    if (equipment.id <= 0) {
      equipment.id = null;
      var newID = await  db.insert(TABLE_NAME, Specification.toMap(equipment));
      var specifications = await Specification.listByProjectFactorSystemAndEquipment(
          db,
          equipment.project,
          equipment.factor,
          equipment.system,
          equipment.equipment
      );
      if( specifications.isNotEmpty ){
        var firstSpecification = specifications[0];
        var requirements = await Requirement.listByProjectFactorSystemEquipmentAndSpecification(db,
            equipment.project,
            equipment.factor,
            equipment.system,
            equipment.equipment,
            firstSpecification.id
        );
        requirements.forEach((rq) {
          rq.specification = newID;
          rq.id = null;
          Requirement.save(db, rq);
        });
      }
      return newID;
    } else {
      return db.update(TABLE_NAME, Specification.toMap(equipment),
          where: "$COLUMN_ID = ?", whereArgs: [equipment.id]);
    }
  }

  static Future<int> delete(Database db, Specification specification) {
    return db.delete(TABLE_NAME,
        where: " $COLUMN_ID = ?", whereArgs: [specification.id]);
  }

  static getDDL() {
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_FACTOR INTEGER, $COLUMN_SYSTEM INTEGER, $COLUMN_EQUIPMENT INTEGER, $COLUMN_NAME TEXT, $COLUMN_WEIGHT INTEGER)';
  }

  static getInsert(Specification specification) {
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_FACTOR, $COLUMN_SYSTEM, $COLUMN_EQUIPMENT, $COLUMN_NAME, $COLUMN_WEIGHT) VALUES(${specification.id}, ${specification.project}, ${specification.factor}, ${specification.system}, ${specification.equipment}, '${specification.name}', ${specification.weight});";
  }
}
