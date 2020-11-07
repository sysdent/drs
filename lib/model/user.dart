import 'package:perforaya/model/entity_model.dart';
import 'package:perforaya/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'user';
const COLUMN_ID = 'id';
const COLUMN_NAME = 'name';
const COLUMN_MAIL = 'mail';
const COLUMN_USERNAME = 'username';
const COLUMN_PASSWORD = 'password';


class User  extends EntityModel{

  String _name;
  String _mail;
  String _username;
  String _password;

  User(int _id, this._name, this._mail, this._username, this._password) : super(_id);

  set name(String name){
    this._name = name;
  }
  set mail(String mail){
    this._mail = mail;
  }
  set username(String username){
    this._username = username;
  }
  set password(String password){
    this._password = password;
  }

  String get name => this._name;
  String get mail => this._mail;
  String get username => this._username;
  String get password => this._password;

  static User fromMap(Map<String, dynamic> map){
    return User(map[COLUMN_ID], map[COLUMN_NAME], map[COLUMN_MAIL], map[COLUMN_USERNAME], map[COLUMN_PASSWORD]);
  }

  static Map<String, dynamic> toMap(User user){
    Map<String, dynamic> map = Map<String, dynamic>();
    map[COLUMN_ID] = user.id;
    map[COLUMN_NAME] = user.name;
    map[COLUMN_MAIL] = user.mail;
    map[COLUMN_USERNAME] = user.username;
    map[COLUMN_PASSWORD] = user.password;
    return map;
  }

  static Future<List<User>> list(Database db, String nameFilter) async {
    var result = await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME ASC');
    List<User> projectList = new List<User>();
    int count = result.length;
    for (int i = 0; i < count; i++) {
      projectList.add(User.fromMap(result[i]));
    }
    return projectList;
  }

  static Future<User> getByUsernameAndPasswordHelper(DatabaseHelper dbHeper, String username, password) async {
    var db = await dbHeper.database;
    var result = await db.query(TABLE_NAME, where: "$COLUMN_USERNAME = ? AND $COLUMN_PASSWORD = ?", whereArgs: [username, password]);
    List<User> specificationList = new List<User>();
    int count = result.length;
    if(count>0) {
      return User.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<User> getByUsernameHelper(DatabaseHelper dbHeper, String username) async {
    var db = await dbHeper.database;
    var result = await db.query(TABLE_NAME, where: "$COLUMN_USERNAME = ?", whereArgs: [username]);
    List<User> specificationList = new List<User>();
    int count = result.length;
    if(count>0) {
      return User.fromMap(result[0]);
    }
    return Future.delayed(Duration(seconds: 0), () => null);
  }

  static Future<int> save(Database db, User user){
    if( user.id <= 0 ){
      user.id = null;
      return db.insert(TABLE_NAME, User.toMap(user));
    }else{
      return db.update(TABLE_NAME, User.toMap(user), where: "$COLUMN_ID = ?", whereArgs: [user.id]);
    }
  }

  static Future<int> delete(Database db, User user) {
    return db.delete(TABLE_NAME, where: " $COLUMN_ID = ?", whereArgs: [user.id]);
  }

  static getDDL(){
    return 'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_NAME TEXT, $COLUMN_MAIL TEXT, $COLUMN_USERNAME TEXT, $COLUMN_PASSWORD TEXT)';
  }

  static getInsert(User user){
    return "INSERT INTO $TABLE_NAME($COLUMN_ID, $COLUMN_NAME, $COLUMN_MAIL, $COLUMN_USERNAME, $COLUMN_PASSWORD) VALUES(${user.id}, '${user.name}', '${user.mail}', '${user.username}', '${user.password}');";
  }
}