import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'offer';
const COLUMN_ID = 'id';
const COLUMN_PROJECT = 'project';
const COLUMN_COMPANY = 'company';
const COLUMN_DRILL_NAME = 'drillName';
const COLUMN_CURRENT_STATUS = 'currentStatus';
const COLUMN_DATE = 'date';
const COLUMN_LOCATION = 'location';
const COLUMN_DATE_LAST_WORK = 'dateLastWork';
const COLUMN_POWER = 'power';
const COLUMN_MAX_LOAD = 'maxLoad';
const COLUMN_RATED_CAPACITY = 'ratedCapacity';
const COLUMN_YEAR = 'year';
const COLUMN_SCORE = 'score';

class Offer extends EntityModel {
  int _project;
  String _company;
  String _drillName;
  String _currentStatus;
  String _date;
  String _location;
  String _dateLastWork;
  String _power;
  String _maxLoad;
  String _ratedCapacity;
  String _year;
  double _score;

  Offer(
      int id,
      this._project,
      this._company,
      this._drillName,
      this._currentStatus,
      this._date,
      this._location,
      this._dateLastWork,
      this._power,
      this._maxLoad,
      this._ratedCapacity,
      this._year)
      : super(id);

  set project(int project) {
    this._project = project;
  }

  set company(String company) {
    this._company = company;
  }

  set drillName(String drillName) {
    this._drillName = drillName;
  }

  set currentStatus(String currentStatus) {
    this._currentStatus = currentStatus;
  }

  set date(String date) {
    this._date = _date;
  }

  set location(String location) {
    this._location = location;
  }

  set dateLastWork(String dateLastWork) {
    this._dateLastWork = dateLastWork;
  }

  set power(String power) {
    this._power = power;
  }

  set maxLoad(String maxLoad) {
    this._maxLoad = maxLoad;
  }

  set ratedCapacity(String ratedCapacity) {
    this._ratedCapacity = ratedCapacity;
  }

  set year(String year) {
    this._year = year;
  }

  set score(double score) {
    this._score = score;
  }

  int get project => this._project;
  String get company => this._company;
  String get drillName => this._drillName;
  String get currentStatus => this._currentStatus;
  String get date => this._date;
  String get location => this._location;
  String get dateLastWork => this._dateLastWork;
  String get power => this._power;
  String get maxLoad => this._maxLoad;
  String get ratedCapacity => this._ratedCapacity;
  String get year => this._year;
  double get score => this._score;

  static Offer fromMap(Map<String, dynamic> map) {
    var offer = Offer(
        map[COLUMN_ID],
        map[COLUMN_PROJECT],
        map[COLUMN_COMPANY],
        map[COLUMN_DRILL_NAME],
        map[COLUMN_CURRENT_STATUS],
        map[COLUMN_DATE],
        map[COLUMN_LOCATION],
        map[COLUMN_DATE_LAST_WORK],
        map[COLUMN_POWER],
        map[COLUMN_MAX_LOAD],
        map[COLUMN_RATED_CAPACITY],
        map[COLUMN_YEAR]);
    offer.score = (map[COLUMN_SCORE] ?? 0)+ .0;
    return offer;
  }

  static Map<String, dynamic> toMap(Offer offer) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = offer.id;
    map[COLUMN_PROJECT] = offer.project;
    map[COLUMN_COMPANY] = offer.company;
    map[COLUMN_DRILL_NAME] = offer.drillName;
    map[COLUMN_CURRENT_STATUS] = offer.currentStatus;
    map[COLUMN_DATE] = offer.date;
    map[COLUMN_LOCATION] = offer.location;
    map[COLUMN_DATE_LAST_WORK] = offer.dateLastWork;
    map[COLUMN_POWER] = offer.power;
    map[COLUMN_MAX_LOAD] = offer.maxLoad;
    map[COLUMN_RATED_CAPACITY] = offer.ratedCapacity;
    map[COLUMN_YEAR] = offer.year;
    map[COLUMN_SCORE] = offer.score;
    return map;
  }

  static Future<Offer> getById(Database db, int id) async{
    var result = await db.query(TABLE_NAME, where: '$COLUMN_ID = ?', whereArgs: [id]);
    int count = result.length;
    if(count>0){
      return Offer.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);;
  }

  static Future<List<Offer>> list(Database db, String nameFilter) async{
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_DRILL_NAME ASC');
    List<Offer> projectList = new List<Offer>();
    int count = result.length;
    for(int i=0; i<count; i++){
      var offerItem = Offer.fromMap(result[i]);
      projectList.add(offerItem);
    }
    return projectList;
  }

  static Future<List<Offer>> listByProject(Database db, int project) async{
    var projects = await Project.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project], orderBy: '$COLUMN_DRILL_NAME ASC');
    List<Offer> projectList = new List<Offer>();
    int count = result.length;
    for(int i=0; i<count; i++){
      var offerItem = Offer.fromMap(result[i]);
      projectList.add(offerItem);
    }
    return projectList;
  }

  static Future<List<Offer>> listByProjectHelper(DatabaseHelper dbHelper, int project) async{
    var db = await dbHelper.database;
    var projects = await Project.list(db, null);
    var result = await db.query(TABLE_NAME, where: "$COLUMN_PROJECT = ?", whereArgs: [project], orderBy: '$COLUMN_DRILL_NAME ASC');
    List<Offer> projectList = new List<Offer>();
    int count = result.length;
    for(int i=0; i<count; i++){
      var offerItem = Offer.fromMap(result[i]);
      projectList.add(offerItem);
    }
    return projectList;
  }

  static Future<int> save(Database db, Offer offer){
    if( offer.id <= 0 ){
      offer.id = null;
      return db.insert(TABLE_NAME, Offer.toMap(offer));
    }else{
      return db.update(TABLE_NAME, Offer.toMap(offer), where: "$COLUMN_ID = ?", whereArgs: [offer.id]);
    }
  }

  static Future<int> delete(Database db, Offer offer) {
    return db.delete(TABLE_NAME, where: " $COLUMN_ID = ?", whereArgs: [offer.id]);
  }

  static getDDL(){
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_PROJECT INTEGER, $COLUMN_COMPANY TEXT, $COLUMN_DRILL_NAME TEXT, $COLUMN_CURRENT_STATUS TEXT, $COLUMN_DATE TEXT, $COLUMN_LOCATION TEXT, $COLUMN_DATE_LAST_WORK TEXT, $COLUMN_POWER TEXT, $COLUMN_MAX_LOAD TEXT, $COLUMN_RATED_CAPACITY TEXT, $COLUMN_YEAR TEXT, $COLUMN_SCORE INTEGER)';
  }

  static getInsert(Offer offer){
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_PROJECT, $COLUMN_COMPANY, $COLUMN_DRILL_NAME, $COLUMN_CURRENT_STATUS, $COLUMN_DATE, $COLUMN_LOCATION, $COLUMN_DATE_LAST_WORK, $COLUMN_POWER, $COLUMN_MAX_LOAD, $COLUMN_RATED_CAPACITY, $COLUMN_YEAR, $COLUMN_SCORE) VALUES(${offer.id}, ${offer.project}, '${offer.company}', '${offer.drillName}', '${offer.currentStatus}', '${offer.date}', '${offer.location}', '${offer.dateLastWork}', '${offer.power}', '${offer.maxLoad}', '${offer.ratedCapacity}', '${offer.year}', ${offer.score});";
  }
}
