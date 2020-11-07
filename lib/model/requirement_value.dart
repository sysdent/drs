import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'requirement_value';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_FACTOR = 'factor';
const COLUMN_SYSTEM = 'system';
const COLUMN_EQUIPMENT = 'equipment';
const COLUMN_SPECIFICATION = 'specification';
const COLUMN_REQUIREMENT = 'requirement';
const COLUMN_OFFER = 'offer';
const COLUMN_VALUE = 'val';
const COLUMN_COMMENT = 'comment';

class RequirementValue extends EntityModel {
  int _project;
  int _factor;
  int _system;
  int _equipment;
  String _equipmentName;
  int _specification;
  int _requirement;
  int _offer;
  String _specificationName;
  int _value;
  String _comment;

  RequirementValue(int id, this._project, this._factor, this._system,
      this._equipment, this._specification, this._requirement, this._offer, this._value, this._comment)
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

  set offer(int offer) {
    this._offer = offer;
  }

  set specification(int specification) {
    this._specification = specification;
  }

  set requirement(int requirement) {
    this._requirement = requirement;
  }

  set value(int value) {
    this._value = value;
  }

  set comment(String comment) {
    this._comment = comment;
  }

  int get project => this._project;
  int get factor => this._factor;
  int get system => this._system;
  int get equipment => this._equipment;
  int get offer => this._offer;
  String get equipmentName => this._equipmentName;
  int get specification => this._specification;
  int get requirement => this._requirement;
  String get specificationName => this._specificationName;
  int get value => this._value;
  String get comment => this._comment;

  static RequirementValue fromMap(Map<String, dynamic> map) {
    return RequirementValue(
        map[COLUMN_ID],
        map[COLUMN_PROJECT],
        map[COLUMN_FACTOR],
        map[COLUMN_SYSTEM],
        map[COLUMN_EQUIPMENT],
        map[COLUMN_SPECIFICATION],
        map[COLUMN_REQUIREMENT],
        map[COLUMN_OFFER],
        map[COLUMN_VALUE],
        map[COLUMN_COMMENT]
    );
  }

  static Map<String, dynamic> toMap(RequirementValue requirement) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = requirement.id;
    map[COLUMN_PROJECT] = requirement.project;
    map[COLUMN_FACTOR] = requirement.factor;
    map[COLUMN_SYSTEM] = requirement.system;
    map[COLUMN_EQUIPMENT] = requirement.equipment;
    map[COLUMN_SPECIFICATION] = requirement.specification;
    map[COLUMN_REQUIREMENT] = requirement.requirement;
    map[COLUMN_OFFER] = requirement.offer;
    map[COLUMN_VALUE] = requirement.value;
    map[COLUMN_COMMENT] = requirement.comment;
    return map;
  }

  static Future<RequirementValue> getByProjectFactorSystemEquipmentSpecificationOfferAndRequirement(Database db,
      int project, int factor, int system, int equipment, int specification, int offer, int requirement) async {
    var result = await db.query(TABLE_NAME,
        where: '$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ?  AND $COLUMN_SYSTEM = ? AND $COLUMN_EQUIPMENT = ? AND $COLUMN_SPECIFICATION = ? AND $COLUMN_OFFER = ? AND $COLUMN_REQUIREMENT = ?',
      whereArgs: [project, factor, system, equipment, specification, offer, requirement]
    );
    if(result.length > 0){
      return Future.delayed(Duration(seconds: 0), () => RequirementValue.fromMap(result[0]));
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<List<RequirementValue>> list(Database db) async {
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_PROJECT ASC, $COLUMN_FACTOR ASC, $COLUMN_SYSTEM ASC, $COLUMN_EQUIPMENT ASC, $COLUMN_SPECIFICATION ASC');
    List<RequirementValue> specificationList = new List<RequirementValue>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = RequirementValue.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<RequirementValue>> listByProject(Database db, int project) async {
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project]);
    List<RequirementValue> specificationList = new List<RequirementValue>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = RequirementValue.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<RequirementValue>> listByOffer(Database db, int offer) async {
    var result = await db.query(TABLE_NAME, where: "$COLUMN_OFFER = ?", whereArgs: [offer]);
    List<RequirementValue> specificationList = new List<RequirementValue>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = RequirementValue.fromMap(result[i]);
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<RequirementValue>> listByProjectAndFactor(Database db, int project, int factor) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ?", whereArgs: [project, factor]);
    List<RequirementValue> specificationList = new List<RequirementValue>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = RequirementValue.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<List<RequirementValue>> listByProjectFactorAndOffer(Database db, int project, int factor, int offer) async {
    var equipments = await Equipment.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_OFFER = ?", whereArgs: [project, factor, offer]);
    List<RequirementValue> specificationList = new List<RequirementValue>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var specificationItem = RequirementValue.fromMap(result[i]);
      specificationItem._equipmentName = equipments.firstWhere((element) => specificationItem.equipment == element.id).name;
      specificationList.add(specificationItem);
    }
    return specificationList;
  }

  static Future<int> save(Database db, RequirementValue equipment) {
    if (equipment.id <= 0) {
      equipment.id = null;
      return db.insert(TABLE_NAME, RequirementValue.toMap(equipment));
    } else {
      return db.update(TABLE_NAME, RequirementValue.toMap(equipment),
          where: "$COLUMN_ID = ?", whereArgs: [equipment.id]);
    }
  }

  static Future<int> delete(Database db, RequirementValue specification) {
    return db.delete(TABLE_NAME,
        where: " $COLUMN_ID = ?", whereArgs: [specification.id]);
  }

  static getDDL() {
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_FACTOR INTEGER, $COLUMN_SYSTEM INTEGER, $COLUMN_EQUIPMENT INTEGER, $COLUMN_SPECIFICATION INTEGER, $COLUMN_REQUIREMENT INTEGER, $COLUMN_OFFER INTEGER, $COLUMN_VALUE INTEGER, $COLUMN_COMMENT TEXT)';
  }

  static getInsert(RequirementValue requirement) {
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_FACTOR, $COLUMN_SYSTEM, $COLUMN_EQUIPMENT, $COLUMN_SPECIFICATION, $COLUMN_REQUIREMENT, $COLUMN_OFFER, $COLUMN_VALUE, $COLUMN_COMMENT) VALUES(${requirement.id}, ${requirement.project}, ${requirement.factor}, ${requirement.system}, ${requirement.equipment}, ${requirement.specification}, ${requirement.id}, ${requirement.offer}, ${requirement.value}, '${requirement.comment}');";
  }
}
