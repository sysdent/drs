import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'factor';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_NAME = 'name';
const COLUMN_WEIGHT = 'weight';
const COLUMN_TYPE = 'type';
const COLUMN_ORDER = 'itemOrder';

const TECHNICAL = 4;
const ENVIRONMENTAL = 1;
const LOGISTIC = 3;
const ECONOMIC = 2;

class Factor extends EntityModel {
  int _project;
  String _name;
  double _weight;
  String _projectName;
  int _type;
  int _order;

  Factor(int id, this._project, this._name, this._weight, this._type, this._order)
      : super(id);

  set project(int project) {
    this._project = project;
  }

  set name(String name) {
    this._name = name;
  }

  set weight(double weight) {
    this._weight = weight;
  }

  set type(int type) {
    this._type = type;
  }

  set order (int order){
    this._order = order;
  }

  int get project => this._project;
  String get projectName => this._projectName;
  String get name => this._name;
  double get weight => this._weight;
  int get type => this._type;
  int get order => this._order;

  static Factor fromMap(Map<String, dynamic> map) {
    return Factor(map[COLUMN_ID], map[COLUMN_PROJECT], map[COLUMN_NAME],
        map[COLUMN_WEIGHT] + .0, map[COLUMN_TYPE], map[COLUMN_ORDER]);
  }

  static Map<String, dynamic> toMap(Factor factor) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = factor.id;
    map[COLUMN_PROJECT] = factor.project;
    map[COLUMN_NAME] = factor.name;
    map[COLUMN_WEIGHT] = factor.weight.toDouble();
    map[COLUMN_TYPE] = factor.type;
    map[COLUMN_ORDER] = factor.order;
    return map;
  }

  static Future<Factor> getById(Database db, int id) async{
    var result = await db.query(TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
    int count = result.length;
    if(count>0){
      return Factor.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<Factor> getByProjectAndType(Database db, int project, int type) async{
    var result = await db.query(TABLE_NAME, where: '$COLUMN_PROJECT = ? AND $COLUMN_TYPE = ?', whereArgs: [project, type], orderBy: "$COLUMN_TYPE");
    int count = result.length;
    if(count>0){
      return Factor.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<List<Factor>> list(Database db, String nameFilter) async {
    var projects = await Project.list(db, null);

    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_TYPE ASC');
    List<Factor> projectList = new List<Factor>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      var factorItem = Factor.fromMap(result[i]);
      factorItem._projectName = projects
          .firstWhere((element) => factorItem.project == element.id)
          .name;
      projectList.add(factorItem);
    }
    return projectList;
  }

  static Future<List<Factor>> listByProject(Database db, int project) async {
    var result = project == null
        ? await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC')
        : await db.query(TABLE_NAME,
            where: "$COLUMN_PROJECT = ?",
            whereArgs: [project],
            orderBy: '$COLUMN_NAME ASC');
    List<Factor> projectList = new List<Factor>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      projectList.add(Factor.fromMap(result[i]));
    }
    return projectList;
  }

  static Future<List<Factor>> listByProjectHelper(DatabaseHelper dbHelper, int project) async{
    var db = await dbHelper.database;
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project], orderBy: '$COLUMN_ORDER ASC');
    List<Factor> projectList = new List<Factor>();
    int count = result.length;
    for(int i=0; i<count; i++){
      var offerItem = Factor.fromMap(result[i]);
      projectList.add(offerItem);
    }
    return projectList;
  }

  static Future<int> save(Database db, Factor factor) {
    if (factor.id <= 0) {
      factor.id = null;
      return db.insert(TABLE_NAME, Factor.toMap(factor));
    } else {
      return db.update(TABLE_NAME, Factor.toMap(factor),
          where: "$COLUMN_ID = ?", whereArgs: [factor.id]);
    }
  }

  static Future<int> delete(Database db, Factor factor) {
    return db
        .delete(TABLE_NAME, where: " $COLUMN_ID = ?", whereArgs: [factor.id]);
  }

  static Future<int> deleteByProject(Database db, Project project) {
    return db.delete(TABLE_NAME,
        where: " $COLUMN_PROJECT = ?", whereArgs: [project.id]);
  }

  static getDDL() {
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_NAME TEXT, $COLUMN_WEIGHT INTEGER, $COLUMN_TYPE INTEGER, $COLUMN_ORDER INTEGER)';
  }

  static getInsert(Factor factor) {
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_NAME, $COLUMN_WEIGHT, $COLUMN_TYPE, $COLUMN_ORDER) VALUES(${factor.id}, ${factor.project}, '${factor.name}', ${factor.weight}, ${factor.type}, ${factor.order});";
  }

  static getTypes() {
    return [
      {"id": ENVIRONMENTAL, "label": "Criterios ambientales"},
      {"id": ECONOMIC, "label": "Criterios economicos"},
      {"id": LOGISTIC, "label": "Criterios logísticos"},
      {"id": TECHNICAL, "label": "Criterios técnicos"},
    ];
  }

  static getLabel(int type){
    return ["", "Criterios ambientales", "Criterios economicos", "Criterios logísticos", "Criterios técnicos"][type];
  }
}
