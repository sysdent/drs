
import 'package:flutter/material.dart';
import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'equipment';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_FACTOR = 'factor';
const COLUMN_SYSTEM = 'system';
const COLUMN_NAME = 'name';
const COLUMN_WEIGHT = 'weight';
const COLUMN_ALLOWSP = 'allowsp';
const COLUMN_STATE = 'state';

class Equipment extends EntityModel{

    int _project;
    int _factor;
    int _system;
    String _name;
    double _weight;
    int _allowsp;
    int _state;

    Equipment(int id, this._project, this._factor, this._system, this._name, this._weight, this._allowsp): super(id);

    set project(int project){
        this._project = project;
    }

    set factor(int factor){
        this._factor = factor;
    }

    set system(int system){
        this._system = system;
    }

    set name(String name){
      this._name = name;
    }

    set weight(double weight){
        this._weight = weight;
    }

    set allowsp(int allowsp){
        this._allowsp = allowsp;
    }

    set state(int state){
        this._state = state;
    }

    int get project => this._project;
    int get factor => this._factor;
    int get system => this._system;
    String get name => this._name;
    double get weight => this._weight;
    int get allowsp => this._allowsp;
    int get state => this._state;

    static Equipment fromMap(Map<String, dynamic> map){
        var equipment = Equipment(map[COLUMN_ID], map[COLUMN_PROJECT], map[COLUMN_FACTOR], map[COLUMN_SYSTEM], map[COLUMN_NAME], map[COLUMN_WEIGHT] + .0, map[COLUMN_ALLOWSP]);
        equipment.state = map[COLUMN_STATE];
        return equipment;
    }

    static Map<String, dynamic> toMap(Equipment equipment){
        Map<String, dynamic> map = Map<String, dynamic>();
        map[COLUMN_ID] = equipment.id;
        map[COLUMN_PROJECT] = equipment.project;
        map[COLUMN_FACTOR] = equipment.factor;
        map[COLUMN_SYSTEM] = equipment.system;
        map[COLUMN_NAME] = equipment.name;
        map[COLUMN_WEIGHT] = equipment.weight;
        map[COLUMN_ALLOWSP] = equipment.allowsp;
        map[COLUMN_STATE] = equipment.state;
        return map;
    }

    static Future<Equipment> getById(Database db, int id) async{
        var result = await db.query(TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
        int count = result.length;
        if(count>0){
            return Equipment.fromMap(result[0]);
        }
        return Future.delayed(Duration(seconds: 0), () => null);
    }

    static Future<List<Equipment>> list(Database db, String nameFilter) async{
        var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC');
        List<Equipment> equipmentList = new List<Equipment>();
        int count = result.length;
        for(int i=0; i<count; i++){
            equipmentList.add(Equipment.fromMap(result[i]));
        }
        return equipmentList;
    }

    static Future<List<Equipment>> listByProject(Database db, int project) async{
        var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project], orderBy: '$COLUMN_NAME ASC');
        List<Equipment> equipmentList = new List<Equipment>();
        int count = result.length;
        for(int i=0; i<count; i++){
            equipmentList.add(Equipment.fromMap(result[i]));
        }
        return equipmentList;
    }

    static Future<List<Equipment>> listByProjectAndState(Database db, int project, int state) async{
        var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_STATE = ?", whereArgs: [project, state], orderBy: '$COLUMN_NAME ASC');
        List<Equipment> equipmentList = new List<Equipment>();
        int count = result.length;
        for(int i=0; i<count; i++){
            equipmentList.add(Equipment.fromMap(result[i]));
        }
        return equipmentList;
    }

    static Future<List<Equipment>> listByProjectFactorAndSystem(Database db, int project, int factor, int system) async{
        var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ?", whereArgs: [project, factor, system], orderBy: '$COLUMN_NAME ASC');
        List<Equipment> equipmentList = new List<Equipment>();
        int count = result.length;
        for(int i=0; i<count; i++){
            equipmentList.add(Equipment.fromMap(result[i]));
        }
        return equipmentList;
    }

    static Future<List<Equipment>> listByProjectFactorAndSystemHelper(DatabaseHelper dbHelper, int project, int factor, int system) async{
        var db = await dbHelper.database;
        var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ? AND $COLUMN_FACTOR = ? AND $COLUMN_SYSTEM = ?", whereArgs: [project, factor, system], orderBy: '$COLUMN_NAME ASC');
        List<Equipment> equipmentList = new List<Equipment>();
        int count = result.length;
        for(int i=0; i<count; i++){
            equipmentList.add(Equipment.fromMap(result[i]));
        }
        return equipmentList;
    }

    static Future<int> save(Database db, Equipment equipment){
        if( equipment.id <= 0 ){
            equipment.id = null;
            return db.insert(TABLE_NAME, Equipment.toMap(equipment));
        }else{
            return db.update(TABLE_NAME, Equipment.toMap(equipment), where: "$COLUMN_ID = ?", whereArgs: [equipment.id]);
        }
    }

    static Future<int> delete(Database db, Equipment equipment) {
        return db.delete(TABLE_NAME, where: " $COLUMN_ID = ?", whereArgs: [equipment.id]);
    }

    static getDDL(){
        return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_FACTOR INTEGER, $COLUMN_SYSTEM INTEGER, $COLUMN_NAME TEXT, $COLUMN_WEIGHT INTEGER, $COLUMN_ALLOWSP INTEGER, $COLUMN_STATE INTEGER DEFAULT 1)';
    }

    static getInsert(Equipment equipment){
        return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_FACTOR, $COLUMN_SYSTEM, $COLUMN_NAME, $COLUMN_WEIGHT, $COLUMN_ALLOWSP, $COLUMN_STATE) VALUES(${equipment.id}, ${equipment.project}, ${equipment.factor}, ${equipment.system}, '${equipment.name}', ${equipment.weight}, ${equipment.allowsp}, ${equipment.state});";
    }
}