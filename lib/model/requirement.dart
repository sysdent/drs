import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'requirement';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_FACTOR = 'factor';
const COLUMN_SYSTEM = 'system';
const COLUMN_EQUIPMENT = 'equipment';
const COLUMN_SPECIFICATION = 'specification';
const COLUMN_LABEL = 'label';
const COLUMN_EXPECTED = 'expected';
const COLUMN_COMMENT = 'comment';
const COLUMN_WEIGHT = 'weight';
const COLUMN_STATE = 'state';

class Requirement extends EntityModel {
  int _project;
  int _factor;
  int _system;
  int _equipment;
  String _equipmentName;
  int _specification;
  String _specificationName;
  String _label;
  String _expected;
  double _weight;
  String _comment;
  int _state;

  Requirement(int id, this._project, this._factor, this._system,
      this._equipment, this._specification, this._label, this._expected, this._weight, this._comment)
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

  set specification(int specification) {
    this._specification = specification;
  }

  set label(String label) {
    this._label = label;
  }

  set expected(String expected) {
    this._expected = expected;
  }

  set weight(double weight) {
    this._weight = weight;
  }

  set comment(String comment) {
    this._comment = comment;
  }

  set state(int state) {
    this._state = state;
  }

  int get project => this._project;
  int get factor => this._factor;
  int get system => this._system;
  int get equipment => this._equipment;
  String get equipmentName => this._equipmentName;
  int get specification => this._specification;
  String get specificationName => this._specificationName;
  String get label => this._label;
  String get expected => this._expected;
  double get weight => this._weight;
  String get comment => this._comment;
  int get state => this._state;

  static Requirement fromMap(Map<String, dynamic> map) {
    var rq = Requirement(
        map[COLUMN_ID],
        map[COLUMN_PROJECT],
        map[COLUMN_FACTOR],
        map[COLUMN_SYSTEM],
        map[COLUMN_EQUIPMENT],
        map[COLUMN_SPECIFICATION],
        map[COLUMN_LABEL],
        map[COLUMN_EXPECTED],
        map[COLUMN_WEIGHT] + .0,
        map[COLUMN_COMMENT],
    );
    rq.state = map[COLUMN_STATE];
    return rq;
  }

  static Map<String, dynamic> toMap(Requirement requirement) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = requirement.id;
    map[COLUMN_PROJECT] = requirement.project;
    map[COLUMN_FACTOR] = requirement.factor;
    map[COLUMN_SYSTEM] = requirement.system;
    map[COLUMN_EQUIPMENT] = requirement.equipment;
    map[COLUMN_SPECIFICATION] = requirement.specification;
    map[COLUMN_LABEL] = requirement.label;
    map[COLUMN_EXPECTED] = requirement.expected;
    map[COLUMN_WEIGHT] = requirement.weight;
    map[COLUMN_COMMENT] = requirement.comment;
    map[COLUMN_STATE] = requirement.state;
    return map;
  }

  static Future<List<Requirement>> list(Database db, String nameFilter) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_PROJECT ASC, $COLUMN_FACTOR ASC, $COLUMN_SYSTEM ASC, $COLUMN_EQUIPMENT ASC, $COLUMN_SPECIFICATION ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Requirement>> listByProject(Database db, int project) async {
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project], orderBy: '$COLUMN_LABEL ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Requirement>> listByProjectActive(Database db, int project) async {
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_STATE = 1", whereArgs: [project], orderBy: '$COLUMN_LABEL ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Requirement>> listByProjectAndFactor(Database db, int project, int factor) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ?", whereArgs: [project, factor], orderBy: '$COLUMN_LABEL ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Requirement>> listByProjectFactorSystemEquipmentAndSpecification(Database db, int project, int factor, int system, int equipment, int specification) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ? AND $COLUMN_SPECIFICATION = ?", whereArgs: [project, factor, system, equipment, specification], orderBy: '$COLUMN_LABEL ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<Requirement>> listByProjectFactorSystemEquipmentAndSpecificationHelper(DatabaseHelper dbHelper, int project, int factor, int system, int equipment, int specification) async {
    var db = await dbHelper.database;
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ? AND $COLUMN_SPECIFICATION = ?", whereArgs: [project, factor, system, equipment, specification], orderBy: '$COLUMN_LABEL ASC');
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = Requirement.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<Requirement> getByProjectFactorSystemEquipmentAndSpecificationHelper(Database db, int project, int factor, int system, int equipment, int specification, int id) async {
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ? AND $COLUMN_SPECIFICATION = ? AND $COLUMN_ID = ?", whereArgs: [project, factor, system, equipment, specification, id]);
    List<Requirement> specificationList = new List<Requirement>();
    int count = result.length;
    if(count>0) {
      return Requirement.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<int> save(Database db, Requirement equipment) {
    if (equipment.id <= 0) {
      equipment.id = null;
      return db.insert(TABLE_NAME, Requirement.toMap(equipment));
    } else {
      return db.update(TABLE_NAME, Requirement.toMap(equipment),
          where: "$COLUMN_ID = ?", whereArgs: [equipment.id]);
    }
  }

  static Future<int> delete(Database db, Requirement specification) {
    return db.delete(TABLE_NAME,
        where: " $COLUMN_ID = ?", whereArgs: [specification.id]);
  }

  static getDDL() {
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_FACTOR INTEGER, $COLUMN_SYSTEM INTEGER, $COLUMN_EQUIPMENT INTEGER, $COLUMN_SPECIFICATION INTEGER, $COLUMN_LABEL TEXT, $COLUMN_EXPECTED TEXT, $COLUMN_WEIGHT INTEGER, $COLUMN_COMMENT TEXT, $COLUMN_STATE INTEGER DEFAULT 1)';
  }

  static getInsert(Requirement requirement) {
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_FACTOR, $COLUMN_SYSTEM, $COLUMN_EQUIPMENT, $COLUMN_SPECIFICATION, $COLUMN_LABEL, $COLUMN_EXPECTED, $COLUMN_WEIGHT, $COLUMN_COMMENT, $COLUMN_STATE) VALUES (${requirement.id}, ${requirement.project}, ${requirement.factor}, ${requirement.system}, ${requirement.equipment}, ${requirement.specification}, '${requirement.label}', '${requirement.expected}', ${requirement.weight}, '${requirement.comment}', ${requirement.state});";
  }
}
