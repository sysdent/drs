
import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'system';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_FACTOR = 'factor';
const COLUMN_NAME = 'name';
const COLUMN_WEIGHT = 'weight';
const COLUMN_ORDER = 'itemOrder';

class System extends EntityModel{

    int _project;
    int _factor;
    String _name;
    double _weight;
    String _projectName;
    String _factorName;
    int _order;

    System(int id, this._project, this._factor, this._name, this._weight, this._order): super(id);

    set project(int project){
        this._project = project;
    }

    set factor(int factor){
        this._factor = factor;
    }

    set name(String name){
      this._name = name;
    }

    set weight(double weight){
        this._weight = weight;
    }

    set order (int order){
        this._order = order;
    }

    int get project => this._project;
    String get projectName => this._projectName;
    int get factor => this._factor;
    String get factorName => this._factorName;
    String get name => this._name;
    double get weight => this._weight;
    int get order => this._order;

    static System fromMap(Map<String, dynamic> map){
        return System(map[COLUMN_ID], map[COLUMN_PROJECT], map[COLUMN_FACTOR], map[COLUMN_NAME], map[COLUMN_WEIGHT] + .0, map[COLUMN_ORDER]);
    }

    static Map<String, dynamic> toMap(System system){
        Map<String, dynamic> map = Map<String, dynamic>();
        map[COLUMN_ID] = system.id;
        map[COLUMN_PROJECT] = system.project;
        map[COLUMN_FACTOR] = system.factor;
        map[COLUMN_NAME] = system.name;
        map[COLUMN_WEIGHT] = system.weight;
        map[COLUMN_ORDER] = system.order;
        return map;
    }

    static Future<System> getById(Database db, int id) async{
        var result = await db.query(TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
        int count = result.length;
        if(count>0){
            return System.fromMap(result[0]);
        }
        return Future.delayed(Duration(seconds: 0), () => null);;
    }

    static Future<List<System>> list(Database db, String nameFilter) async{
        var projects = await Project.list(db, null);
        var factors = await Factor.list(db, null);
        var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_ORDER ASC');
        List<System> projectList = new List<System>();
        int count = result.length;
        for(int i=0; i<count; i++){
            var systemItem = System.fromMap(result[i]);
            systemItem._projectName = projects.firstWhere((element) => systemItem.project == element.id).name;
            systemItem._factorName = factors.firstWhere((element) => systemItem.factor == element.id).name;
            projectList.add(systemItem);
        }
        return projectList;
    }

    static Future<List<System>> listByProject(Database db, int project) async{
        var projects = await Project.list(db, null);
        var factors = await Factor.list(db, null);
        var result = await db.query(TABLE_NAME, where: "project = ?", whereArgs: [project], orderBy: '$COLUMN_ORDER ASC');
        List<System> projectList = new List<System>();
        int count = result.length;
        for(int i=0; i<count; i++){
            var systemItem = System.fromMap(result[i]);
            systemItem._projectName = projects.firstWhere((element) => systemItem.project == element.id).name;
            systemItem._factorName = factors.firstWhere((element) => systemItem.factor == element.id).name;
            projectList.add(systemItem);
        }
        return projectList;
    }

    static Future<List<System>> listByProjectAndFactor(Database db, int project, int factor) async{
        var projects = await Project.list(db, null);
        var factors = await Factor.list(db, null);
        var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ?", whereArgs: [project, factor], orderBy: '$COLUMN_ORDER ASC');
        List<System> projectList = new List<System>();
        int count = result.length;
        for(int i=0; i<count; i++){
            var systemItem = System.fromMap(result[i]);
            systemItem._projectName = projects.firstWhere((element) => systemItem.project == element.id).name;
            systemItem._factorName = factors.firstWhere((element) => systemItem.factor == element.id).name;
            projectList.add(systemItem);
        }
        return projectList;
    }

    static Future<List<System>> listByFactorAndProject(Database db, int project, int factor) async{
        var projects = await Project.list(db, null);
        var factors = await Factor.list(db, null);
        var result = await db.query(TABLE_NAME, where: "project = ? AND factor = ?", whereArgs: [project, factor], orderBy: '$COLUMN_ORDER ASC');
        List<System> projectList = new List<System>();
        int count = result.length;
        for(int i=0; i<count; i++){
            var systemItem = System.fromMap(result[i]);
            systemItem._projectName = projects.firstWhere((element) => systemItem.project == element.id).name;
            systemItem._factorName = factors.firstWhere((element) => systemItem.factor == element.id).name;
            projectList.add(systemItem);
        }
        return projectList;
    }

    static Future<List<System>> listByProjectHelper(DatabaseHelper dbHelper, int project, int factor) async{
        var db = await dbHelper.database;
        var projects = await Project.list(db, null);
        var factors = await Factor.list(db, null);
        var result = await db.query(TABLE_NAME, where: "project = ? AND factor = ?", whereArgs: [project, factor], orderBy: '$COLUMN_ORDER ASC');
        List<System> projectList = new List<System>();
        int count = result.length;
        for(int i=0; i<count; i++){
            var systemItem = System.fromMap(result[i]);
            systemItem._projectName = projects.firstWhere((element) => systemItem.project == element.id).name;
            systemItem._factorName = factors.firstWhere((element) => systemItem.factor == element.id).name;
            projectList.add(systemItem);
        }
        return projectList;
    }

    static Future<int> save(Database db, System system){
        if( system.id <= 0 ){
            system.id = null;
            return db.insert(TABLE_NAME, System.toMap(system));
        }else{
            return db.update(TABLE_NAME, System.toMap(system), where: "$COLUMN_ID = ?", whereArgs: [system.id]);
        }
    }

    static Future<int> delete(Database db, System system) {
        return db.delete(TABLE_NAME, where: " $COLUMN_ID = ?", whereArgs: [system.id]);
    }

    static getDDL(){
        return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_FACTOR INTEGER, $COLUMN_NAME TEXT, $COLUMN_WEIGHT INTEGER, $COLUMN_ORDER INTEGER)';
    }

    static getInsert(System system){
        return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_FACTOR, $COLUMN_NAME, $COLUMN_WEIGHT) VALUES(${system.id}, ${system.project}, ${system.factor}, '${system.name}', ${system.weight});";
    }
}