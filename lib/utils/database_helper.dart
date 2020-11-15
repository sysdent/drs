import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:perforaya/model/equipment.dart';
import 'package:perforaya/model/especification.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/requirement_value.dart';
import 'package:perforaya/model/system.dart';
import 'package:perforaya/model/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'perforaya.db';
    var appDatabase = openDatabase(path, version: 1, onCreate: _createDatabase);
    return appDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    print("Creando la base de datos...");
    await db.execute(Project.getDDL());
    await db.execute(Factor.getDDL());
    await db.execute(System.getDDL());
    await db.execute(Equipment.getDDL());
    await db.execute(Specification.getDDL());
    await db.execute(Requirement.getDDL());
    await db.execute(RequirementValue.getDDL());
    await db.execute(Offer.getDDL());
    await db.execute(User.getDDL());

    await db.execute("INSERT INTO user(id, name, mail, username, password) VALUES(1, 'Administrador del sistema', 'admin@perforaya.com', 'admin', 'qwerty1*');");

    await db.execute("INSERT INTO project(id, name, owuser) VALUES(1, 'Plantilla', 1);");

    await db.execute(
        "INSERT INTO factor(id, project, name, weight, type, itemOrder) VALUES(1, 1, 'Criterios ambientales', 30.0, 1, 2);");
    await db.execute(
        "INSERT INTO factor(id, project, name, weight, type, itemOrder) VALUES(2, 1, 'Criterios económicos', 0.0, 2, 4);");
    await db.execute(
        "INSERT INTO factor(id, project, name, weight, type, itemOrder) VALUES(3, 1, 'Criterios logísticos', 30.0, 3, 3);");
    await db.execute(
        "INSERT INTO factor(id, project, name, weight, type, itemOrder) VALUES(4, 1, 'Criterios técnicos', 40.0, 4, 1);");

    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(1, 1, 1, 'Ruido', 50, 1);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(12, 1, 1, 'Material Particulado ', 50, 2);");

    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(2, 1, 2, 'Económicos', 100, 1);");

    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(4, 1, 3, 'Experiencia del taladro', 9.09, 1);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(13, 1, 3, 'Experiencia del personal ', 9.09, 2);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(14, 1, 3, 'Equipos críticos', 9.09, 3);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(15, 1, 3, 'Logística de movilización ', 9.09, 4);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(16, 1, 3, 'Estado actual del taladro ', 9.09, 5);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(17, 1, 3, 'Covid-19', 9.09, 6);");

    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(3, 1, 4, 'Equipos adicionales', 9.09, 7);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(5, 1, 4, 'Sarta de perforación', 9.09, 6);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(6, 1, 4, 'Sistema de circulación', 9.09, 4);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(7, 1, 4, 'Sistema de control', 9.09, 3);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(8, 1, 4, 'Sistema de levantamiento', 9.09, 1);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(9, 1, 4, 'Sistema de potencia', 9.09, 2);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(10, 1, 4, 'Sistema de rotación', 9.09, 5);");
    await db.execute(
        "INSERT INTO system(id, project, factor, name, weight, itemOrder) VALUES(11, 1, 4, 'Otros', 9.09, 8);");

    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(1, 1, 4, 8, 'Malacate', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(2, 1, 4, 8, 'Mastil/Subestructura', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(3, 1, 4, 8, 'Bloque viajero', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(4, 1, 4, 8, 'Bloque Corona', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(5, 1, 4, 8, 'Cable de perforacion', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(6, 1, 4, 9, 'Sistema de potencia', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(7, 1, 4, 7, 'Equipo BOP', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(8, 1, 4, 7, 'Spacer spool', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(9, 1, 4, 7, 'Drilling spool', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(10, 1, 4, 7, 'Double Studded Adapters', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(11, 1, 4, 7, 'BOP Handling Equipment', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(12, 1, 4, 7, 'BOP Test Stump', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(13, 1, 4, 7, 'BOP Control Unit', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(14, 1, 4, 7, 'Stripping Equipment', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(15, 1, 4, 7, 'BOP Wrench/llave inglesa', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(16, 1, 4, 7, 'Portable BOP Test Unit', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(17, 1, 4, 7, 'Bell Nipple', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(18, 1, 4, 6, 'Sistema de circulacion', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(19, 1, 4, 6, 'Bombas de lodo', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(20, 1, 4, 6, 'Tanques de lodo/ Bulk Storage', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(21, 1, 4, 6, 'Tanque Activo', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(22, 1, 4, 6, 'Tanque reserva', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(23, 1, 4, 6, 'Tanque de viaje', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(24, 1, 4, 6, 'Mezclador de lodo', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(25, 1, 4, 6, 'Control de solidos', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(26, 1, 4, 6, 'Degasser', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(27, 1, 4, 6, 'Mud-gas separator', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(28, 1, 4, 6, 'Tanque de agua', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(29, 1, 4, 6, 'Pvt system', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(30, 1, 4, 10, 'TOP DRIVE', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(31, 1, 4, 10, 'Mesa rotaria', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(32, 1, 4, 10, 'Autodriller', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(33, 1, 4, 10, 'Rotating mousehole', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(34, 1, 4, 5, 'Hand Slips', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(35, 1, 4, 5, 'Manual Tongs for DP y Casing', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(36, 1, 4, 5, 'Tubing tong', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(37, 1, 4, 5, 'Drill pipe spinning tong', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(38, 1, 4, 5, 'Iron roughneck ', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(39, 1, 4, 5, 'Safety Clamps', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(40, 1, 4, 5, 'Tubular Drifts', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(41, 1, 4, 5, 'Bit breakers', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(42, 1, 4, 5, 'Casing Fill-up Line/ Well Fill-Up line', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(43, 1, 4, 5, 'Drill Pipe', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(44, 1, 4, 5, 'Drill pipe Pup Joints', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(45, 1, 4, 5, 'Heavy Weight Drill Pipe', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(46, 1, 4, 5, 'Drill Collars', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(47, 1, 4, 5, 'Lifting Subs', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(48, 1, 4, 5, 'Bit subs', 1, 1);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(49, 1, 4, 5, 'Saver subs', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(50, 1, 4, 5, 'Crossover', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(51, 1, 4, 3, 'Horizontal bucking machine', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(52, 1, 4, 3, 'Mud bucket', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(53, 1, 4, 3, 'Tuggers/Winches', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(54, 1, 4, 3, 'Tubular PU/LD System o Catwalk', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(55, 1, 4, 3, 'Aerial Work platform/Man Lift', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(56, 1, 4, 3, 'Montacargas', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(57, 1, 4, 3, 'Main lighting', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(58, 1, 4, 3, 'Luz portable', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(59, 1, 4, 3, 'Perimetro de la luz', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(60, 1, 4, 3, 'Luz de emergencia', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(61, 1, 4, 3, 'Tanques de combustible', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(62, 1, 4, 3, 'Welding & Cutting', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(63, 1, 4, 3, 'Hand tools', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(64, 1, 4, 3, 'Chicksan - junta giratoria', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(65, 1, 4, 3, 'Pipe Racks', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(66, 1, 4, 3, 'Vac Unit', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(67, 1, 4, 3, 'Air Hoses & Squeegies', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(68, 1, 4, 3, 'Eye Wash Stations / Drench Showers', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(69, 1, 4, 3, 'Rig Skidding Equipment', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(70, 1, 4, 3, 'Full Opening Safety Valves', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(71, 1, 4, 3, 'Inside BOPs', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(72, 1, 4, 3, 'Side Entry subs', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(73, 1, 4, 3, 'Circulating Head', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(74, 1, 4, 3, 'Ported Float Valves', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(75, 1, 4, 3, 'Elevadores', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(76, 1, 4, 3, 'Indicador de parametros', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(77, 1, 4, 11, 'EPP', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(78, 1, 4, 11, 'Sistema de deteccion de fuego', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(79, 1, 4, 11, 'Bomba contra incendios', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(80, 1, 4, 11, 'Senales de advertencia', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(81, 1, 4, 11, 'Proteccion/ Detector de Gases', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(82, 1, 4, 11, 'Kit de deteccion de tormentas', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(83, 1, 4, 11, 'Kit de primeros auxilios', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(84, 1, 4, 11, 'Doctor', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(85, 1, 4, 11, 'Cisterna de agua', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(86, 1, 4, 11, 'Operador de radio', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(87, 1, 4, 11, 'Ambulancia y enfermeria', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(88, 1, 4, 11, 'Equipo para trabajo en alturas', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(89, 1, 4, 11, 'Aparato de respiracion', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(90, 1, 4, 11, 'Proteccion contra rayos', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(91, 1, 4, 11, 'Campamento principal', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(92, 1, 4, 11, 'Campamento alterno', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(93, 1, 4, 11, 'Sistema de intercomunicacion', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(94, 1, 4, 11, 'Sistema de radios', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(95, 1, 4, 11, 'Sistema satelital', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(96, 1, 4, 11, 'Banos portables en el taladro y en el campamento', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(97, 1, 4, 11, 'Wire Rope Slings (Guayas)', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(98, 1, 4, 11, 'Repuestos y lubricantes', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(99, 1, 4, 11, 'Alarmas', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(100, 1, 4, 11, 'Camara', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(101, 1, 4, 11, 'Plan de gestion de residuos', 1, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(102, 1, 4, 11, 'Programa de objetos caidos', 1, 0);");

    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(112, 1, 2, 2, 'Económicos ', 100, 0);");

    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(111, 1, 3, 17, 'Covid-19 ', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(108, 1, 3, 14, 'Equipos críticos ', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(110, 1, 3, 16, 'Estado actual del taladro ', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(106, 1, 3, 13, 'Experiencia del personal ', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(105, 1, 3, 4, 'Experiencia del taladro ', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(107, 1, 3, 13, 'Listado del personal', 1.0, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(109, 1, 3, 15, 'Logística de movilización ', 1.0, 0)");

    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(104, 1, 1, 12, 'Material Particulado', 100, 0);");
    await db.execute(
        "INSERT INTO equipment(id, project, factor, system, name, weight, allowsp) VALUES(103, 1, 1, 1, 'Ruido', 100, 0);");

    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(1, 1, 4, 8, 1, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(2, 1, 4, 8, 2, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(3, 1, 4, 8, 3, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(4, 1, 4, 8, 4, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(5, 1, 4, 8, 5, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(6, 1, 4, 9, 6, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(7, 1, 4, 7, 7, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(8, 1, 4, 7, 8, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(9, 1, 4, 7, 9, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(10, 1, 4, 7, 10, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(11, 1, 4, 7, 11, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(12, 1, 4, 7, 12, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(13, 1, 4, 7, 13, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(14, 1, 4, 7, 14, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(15, 1, 4, 7, 15, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(16, 1, 4, 7, 16, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(17, 1, 4, 7, 17, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(18, 1, 4, 6, 18, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(19, 1, 4, 6, 19, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(20, 1, 4, 6, 20, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(21, 1, 4, 6, 21, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(22, 1, 4, 6, 22, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(23, 1, 4, 6, 23, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(24, 1, 4, 6, 24, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(25, 1, 4, 6, 25, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(26, 1, 4, 6, 26, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(27, 1, 4, 6, 27, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(28, 1, 4, 6, 28, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(29, 1, 4, 6, 29, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(30, 1, 4, 10, 30, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(31, 1, 4, 10, 31, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(32, 1, 4, 10, 32, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(33, 1, 4, 10, 33, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(34, 1, 4, 5, 34, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(35, 1, 4, 5, 35, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(36, 1, 4, 5, 36, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(37, 1, 4, 5, 37, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(38, 1, 4, 5, 38, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(39, 1, 4, 5, 39, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(40, 1, 4, 5, 40, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(41, 1, 4, 5, 41, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(42, 1, 4, 5, 42, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(43, 1, 4, 5, 43, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(44, 1, 4, 5, 44, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(45, 1, 4, 5, 45, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(46, 1, 4, 5, 46, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(47, 1, 4, 5, 47, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(48, 1, 4, 5, 48, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(49, 1, 4, 5, 49, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(50, 1, 4, 5, 50, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(51, 1, 4, 3, 51, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(52, 1, 4, 3, 52, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(53, 1, 4, 3, 53, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(54, 1, 4, 3, 54, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(55, 1, 4, 3, 55, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(56, 1, 4, 3, 56, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(57, 1, 4, 3, 57, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(58, 1, 4, 3, 58, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(59, 1, 4, 3, 59, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(60, 1, 4, 3, 60, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(61, 1, 4, 3, 61, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(62, 1, 4, 3, 62, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(63, 1, 4, 3, 63, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(64, 1, 4, 3, 64, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(65, 1, 4, 3, 65, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(66, 1, 4, 3, 66, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(67, 1, 4, 3, 67, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(68, 1, 4, 3, 68, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(69, 1, 4, 3, 69, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(70, 1, 4, 3, 70, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(71, 1, 4, 3, 71, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(72, 1, 4, 3, 72, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(73, 1, 4, 3, 73, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(74, 1, 4, 3, 74, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(75, 1, 4, 3, 75, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(76, 1, 4, 3, 76, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(77, 1, 4, 11, 77, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(78, 1, 4, 11, 78, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(79, 1, 4, 11, 79, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(80, 1, 4, 11, 80, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(81, 1, 1, 1, 81, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(82, 1, 4, 11, 82, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(83, 1, 4, 11, 83, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(84, 1, 4, 11, 84, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(85, 1, 4, 11, 85, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(86, 1, 4, 11, 86, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(87, 1, 4, 11, 87, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(88, 1, 4, 11, 88, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(89, 1, 4, 11, 89, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(90, 1, 4, 11, 90, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(91, 1, 4, 11, 91, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(92, 1, 4, 11, 92, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(93, 1, 4, 11, 93, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(94, 1, 4, 11, 94, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(95, 1, 4, 11, 95, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(96, 1, 4, 11, 96, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(97, 1, 4, 11, 97, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(98, 1, 4, 11, 98, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(99, 1, 4, 11, 99, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(100, 1, 4, 11, 100, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(101, 1, 4, 11, 101, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(102, 1, 4, 11, 102, 'Especificación #1', 100);");

    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(103, 1, 1, 1, 103, 'Especificación #1', 100);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(104, 1, 1, 12, 104, 'Especificación #1', 100.0);");

    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(105, 1, 3, 4, 105, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(106, 1, 3, 13, 106, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(107, 1, 3, 13, 107, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(108, 1, 3, 14, 108, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(109, 1, 3, 15, 109, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(110, 1, 3, 16, 110, 'Especificación #1', 100.0);");
    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(111, 1, 3, 17, 111, 'Especificación #1', 100.0);");

    await db.execute(
        "INSERT INTO specification(id, project, factor, system, equipment, name, weight) VALUES(112, 1, 2, 2, 112, 'Especificación #1', 100.0);");

    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(1, 1, 4, 8, 1, 1, ' Potencia minima requerida', '3000 HP', 0.1, 'Indique la potencia del equipo');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(183, 1, 4, 5, 50, 50, '*Escribir las especificaciones*', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(212, 1, 4, 3, 66, 66, '*especificación en comentarios ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(51, 1, 4, 7, 16, 16, 'Acumulador con registrador de presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(82, 1, 4, 6, 21, 21, 'Agitadores ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(90, 1, 4, 6, 22, 22, 'Agitadores ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(233, 1, 4, 11, 99, 99, 'Alarmas en la zona del taladro, luz pars zonas de alto ruido y alarmas de detección de altos niveles de gas y h2s', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(249, 1, 4, 11, 91, 91, 'Almacenamiento de agua potable ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(190, 1, 4, 3, 55, 55, 'Altura de la plataforma', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(305, 1, 4, 3, 55, 55, 'Certificado', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(264, 1, 4, 11, 87, 87, 'Ambulancia y enfermería con equipo esencial básico de acuerdo a la resolución 1043 de 2006', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(266, 1, 4, 11, 89, 89, 'Aparatos de respiración ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(122, 1, 4, 6, 29, 29, 'Aprobación CSA', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(250, 1, 4, 11, 91, 91, 'Baños ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(236, 1, 4, 11, 96, 96, 'Baños portátiles en la zona del taladro y del campamento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(147, 1, 4, 5, 41, 41, 'Bit breakers', '', 1.0, 'Para los tipos de broca a usar');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(256, 1, 4, 11, 79, 79, 'Bomba contra incendios ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(102, 1, 4, 6, 24, 24, 'Bombas de baja presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(103, 1, 4, 6, 24, 24, 'Bombas de mezcla ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(136, 1, 4, 10, 31, 31, 'Bowl insert for casing', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(11, 1, 4, 8, 2, 2, 'Bumper blocks', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(89, 1, 4, 6, 22, 22, 'Cable que pueda balancear el peso del lodo a la hora de ser levantado', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(26, 1, 4, 8, 5, 5, 'Calibre del cable', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(245, 1, 4, 11, 91, 91, 'Camas por habitación ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(262, 1, 4, 11, 85, 85, 'Camión cisterna y su correspondiente conductor', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(207, 1, 4, 3, 64, 64, 'Cantidad', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(213, 1, 4, 3, 67, 67, 'Cantidad', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(114, 1, 4, 6, 28, 28, 'Cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(167, 1, 4, 5, 46, 46, 'Cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(304, 1, 4, 5, 46, 46, 'Conexión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(179, 1, 4, 5, 48, 48, 'Cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(195, 1, 4, 3, 56, 56, 'Cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(197, 1, 4, 3, 58, 58, 'Cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(37, 1, 4, 7, 10, 10, 'Cantidad de Double studded adapters requeridos para los diámetros de los BOPs', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(34, 1, 4, 7, 9, 9, 'Cantidad de Spacer Spool requeridos para los diámetros de los BOP', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(302, 1, 4, 7, 8, 8, 'Cantidad requerida para los diámetros de los BOP', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(69, 1, 4, 6, 19, 19, 'Cantidad de bombas', '', 1.0, 'Escribir el tipo que se requiere como comentario');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(160, 1, 4, 5, 45, 45, 'Cantidad de juntas ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(182, 1, 4, 5, 49, 49, 'Cantidad de saver subs a utilizar para cada Drill pipe', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(106, 1, 4, 6, 25, 25, 'Cantidad mínima de shale shakers', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(220, 1, 4, 3, 74, 74, 'Cantidad para cada tipo de DC', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(217, 1, 4, 3, 71, 71, 'Cantidad para cada tipo de DP', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(219, 1, 4, 3, 73, 73, 'Cantidad para cada tipo de DP', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(216, 1, 4, 3, 70, 70, 'Cantidad para cada tipo de DP y xover', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(175, 1, 4, 5, 46, 46, 'Cantidad y Longitud de Pony DC', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(221, 1, 4, 3, 75, 75, 'Cantidad y capacidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(187, 1, 4, 3, 53, 53, 'Capacidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(193, 1, 4, 3, 55, 55, 'Capacidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(112, 1, 4, 6, 26, 26, 'Capacidad Mínima ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(124, 1, 4, 10, 30, 30, 'Capacidad de carga ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(135, 1, 4, 10, 31, 31, 'Capacidad de carga ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(2, 1, 4, 8, 1, 1, 'Capacidad de levantamiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(38, 1, 4, 7, 11, 11, 'Capacidad de levantamiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(244, 1, 4, 11, 91, 91, 'Capacidad de personas ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(19, 1, 4, 8, 3, 3, 'Capacidad del bloque viajero', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(48, 1, 4, 7, 14, 14, 'Capacidad del equipo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(18, 1, 4, 8, 3, 3, 'Capacidad del gancho ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(23, 1, 4, 8, 4, 4, 'Capacidad en el bloque corona', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(87, 1, 4, 6, 22, 22, 'Capacidad mínima ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(200, 1, 4, 3, 61, 61, 'Capacidad mínima ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(81, 1, 4, 6, 21, 21, 'Capacidad mínima aproximada ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(93, 1, 4, 6, 23, 23, 'Capacidad mínima aproximada ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(107, 1, 4, 6, 25, 25, 'Capacidad mínima de manejo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(115, 1, 4, 6, 28, 28, 'Capacidad mínima requerida ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(105, 1, 4, 6, 24, 24, 'Capacidad para transferir el fluido en ambos sentidos entre los tanques activos y de reserva', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(192, 1, 4, 3, 55, 55, 'Capacidad sin restricción ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(148, 1, 4, 5, 42, 42, 'Casing fill-up & well fill-up line', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(74, 1, 4, 6, 19, 19, 'Charging pumps', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(46, 1, 4, 7, 13, 13, 'Choke Manifold', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(36, 1, 4, 7, 9, 9, 'Choke line ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(153, 1, 4, 5, 43, 43, 'Clase ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(247, 1, 4, 11, 91, 91, 'Cocina, comedor y zona de lavandería ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(240, 1, 4, 11, 92, 92, 'Comedores para trabajos de oficina', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(164, 1, 4, 5, 45, 45, 'Conexión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(64, 1, 4, 6, 18, 18, 'Conexión con bridas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(121, 1, 4, 6, 29, 29, 'Contador de emboladas por cada pozo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(42, 1, 4, 7, 12, 12, 'Crossovers para permitir pruebas de TIW en el equipo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(189, 1, 4, 3, 54, 54, 'Cuenta con ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(55, 1, 4, 7, 17, 17, 'Cumple con las especificacion para conectarlo al preventor anular ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(45, 1, 4, 7, 13, 13, 'Cumplimiento de la norma API STD 53 para el fluido de los acumuladores', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(110, 1, 4, 6, 25, 25, 'Desander', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(111, 1, 4, 6, 25, 25, 'Desilter', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(191, 1, 4, 3, 55, 55, 'Distancia horizontal ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(77, 1, 4, 6, 20, 20, 'Ditch System - para permitir el movimientos de fluidos entre tanques', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(56, 1, 4, 7, 7, 7, 'Diámetro ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(150, 1, 4, 5, 43, 43, 'Diámetro ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(161, 1, 4, 5, 45, 45, 'Diámetro ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(20, 1, 4, 8, 3, 3, 'Diámetro de la polea ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(176, 1, 4, 5, 47, 47, 'Diámetro y cantidad', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(261, 1, 4, 11, 84, 84, 'Doctor con estudios validados', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(143, 1, 4, 5, 37, 37, 'Drillpipe spinning tong', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(7, 1, 4, 8, 1, 1, 'El sonido emitido está entre los niveles permitidos por las leyes Colombianas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(22, 1, 4, 8, 3, 3, 'Elevator links', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(201, 1, 4, 3, 61, 61, 'Equipado con indicador visual, calibración en pulgadas, medidor de flujo para el flujo de entrada y salida del tanquey dispositivo de cierre automático ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(204, 1, 4, 3, 62, 62, 'Equipo de corte ', '', 1.0, 'Cuenta con');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(251, 1, 4, 11, 91, 91, 'Equipo de emergencia comprendido de alarmas, señalización y equipos contra incendios ', '', 1.0, '');");
    await db.execute(
        """INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(254, 1, 4, 11, 77, 77, 'Equipo de protección personal ', '', 1.0, '-Ropa de seguridad (se requieren mangas largas)
            -Overoles requeridos para manejos de OBM
    -NOMEX o overoles resistentes a los incendios para el personal acorde al analisis de riesgo
        -Los overoles TYVEK serán proporcionados por el contratista de la plataforma
    -Casco no metálico aprobado por MSA
    -Gafas de seguridad con protección lateral adjunta.
    -Gafas donde sea necesario
    -Máscaras contra el polvo, respiradores de doble recipiente y otros tipos de respiradores según lo requiera la MSDS química
    -Guantes  de cuero, caucho, algodón, nitrilo y cuttings según sea necesario.
    -Protector Solar
        -Botas de cuero con punta de acero o botas de caucho con punta de acero para el personal de acuerdo con el análisis de riesgo del Contratista
        -Linternas de mano a prueba de explosiones completas con baterías
    -Barrier creams para trabajar con OBM');""");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(258, 1, 4, 11, 81, null, 'Equipo de protección y detección de gases', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(205, 1, 4, 3, 62, 62, 'Equipo de soldadura ', '', 1.0, 'Cuenta con');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(265, 1, 4, 11, 88, 88, 'Equipo para trabajo en alturas con líneas de seguridad instaladas en todas las áreas donde se va a trabajar a alturas mayores a 1.5 metros, cumpliendo con las normas de MSA y OSHA', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(242, 1, 4, 11, 92, 92, 'Equipos de oficina compuestos de alarmas, señalización y equipos contra incendios', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(177, 1, 4, 5, 48, 48, 'Espacio para válvula flotadora', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(75, 1, 4, 6, 19, 19, 'Filtro de Succión y descarga ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(4, 1, 4, 8, 1, 1, 'Freno Auxiliae', '', 1.0, 'En caso de emergencia');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(5, 1, 4, 8, 1, 1, 'Freno eléctrico ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(52, 1, 4, 7, 16, 16, 'Fuente de alimentación ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(151, 1, 4, 5, 43, 43, 'Grado', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(140, 1, 4, 5, 34, 34, 'Hands slips', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(99, 1, 4, 6, 24, 24, 'Hoppers en el sistema', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(169, 1, 4, 5, 46, 46, 'ID', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(196, 1, 4, 3, 57, 57, 'Iluminación principal que cumpla con ls norma API RP 500B', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(94, 1, 4, 6, 23, 23, 'Incremental volume ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(43, 1, 4, 7, 13, 13, 'Independent and operational hydraulic charging systems', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(226, 1, 4, 3, 76, 76, 'Indicador de RPM', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(225, 1, 4, 3, 76, 76, 'Indicador de SPM', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(95, 1, 4, 6, 23, 23, 'Indicador de nivel', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(119, 1, 4, 6, 29, 29, 'Indicador de nivel de lodo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(222, 1, 4, 3, 76, 76, 'Indicador de peso', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(223, 1, 4, 3, 76, 76, 'Indicador de torque ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(228, 1, 4, 3, 76, 76, 'Indicador del nivel de lodo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(14, 1, 4, 8, 2, 2, 'Intermediate racking board', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(157, 1, 4, 5, 44, 44, 'Internal plastic coating', '', 1.0, 'Para cada tipo de Drillpipe');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(303, 1, 4, 5, 43, 43, 'Peso nominal', '', 1.0, '');");

    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(165, 1, 4, 5, 45, 45, 'Internal plastic coating', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(144, 1, 4, 5, 38, 38, 'Iron roughneck', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(35, 1, 4, 7, 9, 9, 'Kill Line', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(259, 1, 4, 11, 82, 82, 'Kit de detección de tormentas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(260, 1, 4, 11, 83, 83, 'Kit de primeros auxilios con los suministros médicos requeridos', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(3, 1, 4, 8, 1, 1, 'Lebus Grooving', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(50, 1, 4, 7, 15, 15, 'Llace hidráulica para todos los tamaños de tuerca', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(149, 1, 4, 5, 43, 43, 'Longitud ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(170, 1, 4, 5, 46, 46, 'Longitud ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(156, 1, 4, 5, 44, 44, 'Longitud y número', '', 1.0, 'Para cada tipo de drill pipe');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(97, 1, 4, 6, 23, 23, 'Manifold del tanque de viaje', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(141, 1, 4, 5, 35, 35, 'Manual tongs for DP and casing', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(16, 1, 4, 8, 2, 2, 'Matting boards', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(116, 1, 4, 6, 28, 28, 'Medidor de flujo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(227, 1, 4, 3, 76, 76, 'Medidor de flujo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(47, 1, 4, 7, 13, 13, 'Medidores de presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(17, 1, 4, 8, 3, 3, 'Minimum hook load capacity', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(9, 1, 4, 8, 2, 2, 'Minimum rotary load', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(8, 1, 4, 8, 2, 2, 'Minimum set-back load', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(30, 1, 4, 9, 6, 6, 'Modelo insonorizado', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(118, 1, 4, 6, 29, 29, 'Monitor de indicadores en la mesa rotaria', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(117, 1, 4, 6, 29, 29, 'Monitoreo de tanques de lodo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(109, 1, 4, 6, 25, 25, 'Mud cleaner', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(101, 1, 4, 6, 24, 24, 'Máxima capacidad de peso de lodo que se puede manejar ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(57, 1, 4, 7, 7, 7, 'Máxima presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(63, 1, 4, 6, 18, 18, 'Máxima presión con la que trabajaría el sistema', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(76, 1, 4, 6, 19, 19, 'Máxima presión de descarga ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(127, 1, 4, 10, 30, 30, 'Máxima velocidad de rotación ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(128, 1, 4, 10, 30, 30, 'Máximo torque ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(13, 1, 4, 8, 2, 2, 'Mínima altura por debajo de las rotary beams', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(215, 1, 4, 3, 69, 69, 'Mínima cantidad de desplazamiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(133, 1, 4, 10, 31, 31, 'Mínimo diámetro de apertura', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(65, 1, 4, 6, 18, 18, 'Mínimo diámetro de linea de descarga ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(28, 1, 4, 9, 6, 6, 'Mínimo número de generadores ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(29, 1, 4, 9, 6, 6, 'Mínimo número de motores ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(59, 1, 4, 7, 7, 7, 'Número de RAMs', '', 1.0, 'Escribir Tipo y diámetro de cada una como comentario');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(98, 1, 4, 6, 23, 23, 'Número de bombas para el tanque de viaje', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(21, 1, 4, 8, 3, 3, 'Número de poleas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(168, 1, 4, 5, 46, 46, 'OD', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(241, 1, 4, 11, 92, 92, 'Oficina para trabajos HSE', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(263, 1, 4, 11, 86, 86, 'Operador de radio con cobertura 24 horas ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(61, 1, 4, 7, 7, 7, 'Outlet size', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(44, 1, 4, 7, 13, 13, 'Panel de control ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(229, 1, 4, 3, 76, 76, 'Parameter recorder', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(6, 1, 4, 8, 1, 1, 'Perforador automático', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(163, 1, 4, 5, 45, 45, 'Peso nominal ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(83, 1, 4, 6, 21, 21, 'Pill Tanks', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(126, 1, 4, 10, 30, 30, 'Pipe handler', '', 1.0, 'Que opere para los diferentes tamaños de tubería');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(231, 1, 4, 11, 101, 101, 'Plan de gestión de residuos ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(70, 1, 4, 6, 19, 19, 'Potencia de entrada ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(71, 1, 4, 6, 19, 19, 'Potencia en el motor de cads bomba', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(137, 1, 4, 10, 31, 31, 'Potencia requerida ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(58, 1, 4, 7, 7, 7, 'Presion de la válvula anular', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(60, 1, 4, 7, 7, 7, 'Presión de las RAMs', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(40, 1, 4, 7, 12, 12, 'Presión de trabajo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(209, 1, 4, 3, 64, 64, 'Presión de trabajo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(224, 1, 4, 3, 76, 76, 'Presión en el stand pipe ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(62, 1, 4, 7, 7, 7, 'Presión que debe soportar el Outlet size', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(230, 1, 4, 11, 102, 102, 'Programa de Objetos caídos ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(267, 1, 4, 11, 90, 90, 'Protección contra rayos para ser instaldo en el campamento, el área de la plataforma y el área de almacenamiento de diesel asegurando el cumplimiento de las normas de seguridad nacionales por parte del Contratista', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(86, 1, 4, 6, 21, 21, 'Protección de corrosión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(92, 1, 4, 6, 22, 22, 'Protección de corrosión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(10, 1, 4, 8, 2, 2, 'Racking capacity', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(162, 1, 4, 5, 45, 45, 'Rango', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(152, 1, 4, 5, 43, 43, 'Rango ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(53, 1, 4, 7, 16, 16, 'Rango de presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(72, 1, 4, 6, 19, 19, 'Rango de tamaño de la camisa', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(194, 1, 4, 3, 55, 55, 'Rated Gradability', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(202, 1, 4, 3, 61, 61, 'Receiving tank isolation', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(27, 1, 4, 8, 5, 5, 'Referencia ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(54, 1, 4, 7, 16, 16, 'Registrador de presión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(234, 1, 4, 11, 98, 98, 'Repuestos críticos de consumo diario y gran variedad de repuestos críticos pars apoyar la operación ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(211, 1, 4, 3, 65, 65, 'Requeridas para el DP y el BHA', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(24, 1, 4, 8, 5, 5, 'Resistencia nominal del cable ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(67, 1, 4, 6, 18, 18, 'Rotary Hose', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(139, 1, 4, 10, 33, 33, 'Rotating mousehole', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(33, 1, 4, 9, 6, 6, 'SCR unit ross hill 1202 5x5 o System I-Drive SCR system', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(145, 1, 4, 5, 39, 39, 'Safety clamps', '', 1.0, 'Para los rangos de tubería necesaria');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(252, 1, 4, 11, 91, 91, 'Salida de emergencia con puertas que se abren hacia afuera y esten designadas ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(243, 1, 4, 11, 92, 92, 'Salidas de emergencia con puertas que se abren hacia afuera ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(84, 1, 4, 6, 21, 21, 'Sand Trap', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(113, 1, 4, 6, 27, 27, 'Separador de gas que cumpla con todas las especificaciones y requerimientos del cliente ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(257, 1, 4, 11, 80, 80, 'Señales de advertencia en idioma español e inglés ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(108, 1, 4, 6, 24, 24, 'Shale shaker con mecanismos de posicionamiento en sus mallas y que permita una variación de la fuerza G', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(129, 1, 4, 10, 30, 30, 'Sistema IBOP', '', 1.0, 'Preferible uno remoto y uno manual');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(138, 1, 4, 10, 32, 32, 'Sistema autodriller', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(255, 1, 4, 11, 78, 78, 'Sistema de detección de incendios ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(120, 1, 4, 6, 29, 29, 'Sistema de detección de patadas de pozo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(31, 1, 4, 9, 6, 6, 'Sistema de distribución de corriente alterna (AC) ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(32, 1, 4, 9, 6, 6, 'Sistema de distribución de corriente directa (DC) ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(239, 1, 4, 11, 93, 93, 'Sistema de intercomunicaciones en puntos previamente identificados ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(130, 1, 4, 10, 30, 30, 'Sistema de limitación de torque5', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(96, 1, 4, 6, 23, 23, 'Sistema de llenado ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(100, 1, 4, 6, 24, 24, 'Sistema de mezcla de química turboshear tipo venturi', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(12, 1, 4, 8, 2, 2, 'Sistema de posicionamiento Crown-o-matic', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(237, 1, 4, 11, 95, 95, 'Sistema satelital', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(174, 1, 4, 5, 46, 46, 'Slip recess', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(203, 1, 4, 3, 62, 62, 'Spark arrestor', '', 1.0, 'Cuenta con');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(134, 1, 4, 10, 31, 31, 'Split master bushing', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(15, 1, 4, 8, 2, 2, 'Stabbing board ajustables', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(66, 1, 4, 6, 18, 18, 'Standpipe', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(41, 1, 4, 7, 12, 12, 'Studded Adapter', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(49, 1, 4, 7, 14, 14, 'Surge bottle for annular preventor, low pressure scale gauge', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(208, 1, 4, 3, 64, 64, 'Tamaño ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(39, 1, 4, 7, 12, 12, 'Tamaño de bridas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(188, 1, 4, 3, 53, 53, 'Tamaño de la línea sugerido ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(78, 1, 4, 6, 20, 20, 'Tanque de Succión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(88, 1, 4, 6, 22, 22, 'Tanque dividido en dos compartimientos conectados por una tubería en \"L\" con un sistema de levantamiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(85, 1, 4, 6, 21, 21, 'Tanques Cubiertos', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(91, 1, 4, 6, 22, 22, 'Tanques cubiertos ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(166, 1, 4, 5, 45, 45, 'Thread protectors', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(173, 1, 4, 5, 46, 46, 'Thread protectors', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(159, 1, 4, 5, 45, 45, 'Tipo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(210, 1, 4, 3, 64, 64, 'Tipo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(172, 1, 4, 5, 46, 46, 'Tipo ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(181, 1, 4, 5, 48, 48, 'Tipo de Bit sub y OD', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(25, 1, 4, 8, 5, 5, 'Tipo de cable', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(154, 1, 4, 5, 43, 43, 'Tipo de conexión ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(180, 1, 4, 5, 48, 48, 'Tipo de conexión y diámetro ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(123, 1, 4, 10, 30, 30, 'Tipo recomendado', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(155, 1, 4, 5, 43, 43, 'Tool joint OD', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(132, 1, 4, 10, 30, 30, 'Top drive rails', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(125, 1, 4, 10, 30, 30, 'Torque wrench', '', 1.0, 'Para todos los tamaños de tubería');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(131, 1, 4, 10, 30, 30, 'Torque wrench jaws', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(142, 1, 4, 5, 36, 36, 'Tubing tongs', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(146, 1, 4, 5, 40, 40, 'Tubumar drifts', '', 1.0, 'Para los rangos de tuberia necesarios');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(253, 1, 4, 11, 91, 91, 'Unidad de eliminación séptica ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(68, 1, 4, 6, 18, 18, 'Vibrator hose', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(80, 1, 4, 6, 20, 20, 'Válvula de aislamiento en las líneas de cada tanque ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(79, 1, 4, 6, 20, 20, 'Válvula de compuerta ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(73, 1, 4, 6, 19, 19, 'Válvula de seguridad flanchada', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(248, 1, 4, 11, 91, 91, 'Zona de almacenamiento de químicos y productos de limpieza ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(178, 1, 4, 5, 48, 48, 'cantidad ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(198, 1, 4, 3, 59, 59, 'cantidad ', '', 1.0, 'Cubre el área del taladro y campamento');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(158, 1, 4, 5, 45, 45, 'cantidad de juntas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(186, 1, 4, 3, 53, 53, 'cantidades', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(184, 1, 4, 3, 51, 51, 'cuenta con', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(185, 1, 4, 3, 52, 52, 'cumple para los diámetros de DP', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(232, 1, 4, 11, 100, 100, 'cámaras en las zonas requeridas ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(206, 1, 4, 3, 63, 63, 'herramientas para el taladro ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(199, 1, 4, 3, 60, 60, 'provee luz para todas las rutas de seguridas y áreas de trabajo', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(218, 1, 4, 3, 72, 72, 'side entry sub', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(238, 1, 4, 11, 94, 94, 'sistemas de radios', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(214, 1, 4, 3, 68, 68, 'ubicación adecuada ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(171, 1, 4, 5, 46, 46, 'w\SGR & BB', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(235, 1, 4, 11, 97, 97, 'wire ropes slings de diferentes tamaños', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(246, 1, 4, 11, 91, 91, 'zonas de recreación ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(104, 1, 4, 6, 24, 24, 'Área de mezcla cubierta ', '', 1.0, '');");

    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(268, 1, 1, 1, 103, 103, '¿Los sistemas de generación cuentan con un sistema de insonorización eficiente y permanente durante el uso en la operación?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(269, 1, 1, 1, 103, 103, '¿El equipo es automático?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(270, 1, 1, 1, 103, 103, '¿La empresa cuenta con un mapa de emisión de ruido (no ocupacional) que demuestre que el nivel de emisión a 50m de distancia desde los equipos no es mayor a 55dB?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(271, 1, 1, 1, 103, 103, '¿La empresa demuestra tener un plan de mantenimiento del equipo en donde se incluya las actividades preventivas y de mitigación de ruido?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(272, 1, 1, 12, 104, 104, '¿La empresa demuestra tener un plan de mantenimiento del equipo en donde se incluya las actividades preventivas y correctivas en sistemas de combustión?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(273, 1, 1, 12, 104, 104, '¿La compañía cuenta con equipos electricos que generen una reducción en la emisión de material particulado a la atmosfera?', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(274, 1, 1, 12, 104, 104, '¿Los equipos que componen el sistema del taladro han operado con anterioridad dentro de los niveles permisibles de emisión de material particulado según estipula la ley colombiana 2254 de 2017 ?', '', 1.0, '');");

    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(296, 1, 2, 2, 112, 112, 'Tarifa por movilización ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(297, 1, 2, 2, 112, 112, 'Tarifa operativa con tubería ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(298, 1, 2, 2, 112, 112, 'Tarifa operativa sin tubería ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(299, 1, 2, 2, 112, 112, 'Tarifa stanby con cuadrilla ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(300, 1, 2, 2, 112, 112, 'Tarifa stanby sin cuadrilla', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(301, 1, 2, 2, 112, 112, 'Tarifa stacked', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(275, 1, 3, 4, 105, 105, 'Experiencia con equipos de potencia ', '', 1.0, 'Indicar potencia');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(276, 1, 3, 4, 105, 105, 'Experiencia en pozos con profundidades mayores o iguales a', '', 1.0, 'Ingresar profundidad');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(277, 1, 3, 4, 105, 105, 'Desempeño observado en % (NPT asociado al taladro ofertado en los últimos 5 pozos) ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(278, 1, 3, 13, 106, 106, 'Modelo de competencias requeridas para todos los cargos técnicos y de supervisión enfocadas a perforación de pozos con profundidades a trabajar', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(279, 1, 3, 13, 106, 106, 'Organigrama de la Organización y Organización propuesta para la ejecución del proyecto desde Gerencia hasta Líderes de Operaciones', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(280, 1, 3, 13, 107, 107, 'Operation Manager', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(281, 1, 3, 13, 107, 107, 'Superintendente ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(282, 1, 3, 13, 107, 107, 'Jefe de mantenimiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(283, 1, 3, 13, 107, 107, 'Tool pusher', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(284, 1, 3, 14, 108, 108, 'Programa de mantenimiento ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(285, 1, 3, 14, 108, 108, 'Trazabilidad de equipos críticos ', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(286, 1, 3, 14, 108, 108, 'Inventario de equipos y repuestos críticos, registros y disponibilidad de éstos en bodega en Colombia', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(287, 1, 3, 15, 109, 109, 'Plan de arranque/Alistamiento y cronograma: presentar protocolo de pre-comisionamiento, plan de pruebas de equipos previo a la movilización, requerimientos de fabricantes de los equipos para arranque (top drive, malacate, bombas, freno auxiliar, VFD o SCR)', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(288, 1, 3, 15, 109, 109, 'Plan de Movilización  y Arme del Taladro (a partir de la primera carga en la ciudad de origen)', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(289, 1, 3, 15, 109, 109, 'Plan de Desarme del Taladro y Desmovilización', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(290, 1, 3, 16, 110, 110, 'Estado actual del taladro', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(291, 1, 3, 17, 111, 111, 'La compañía del trabajo cuenta con un protocolo de bioseguridad referente al Covid-19 y conoce los protocolos de la empresa operadora y demás compañías prestadoras de servicio involucradas', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(292, 1, 3, 17, 111, 111, 'Se tienen los protocolos requeridos para la zona del comedor y medidas necesarias para reducir el riesgo en esta zona', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(293, 1, 3, 17, 111, 111, 'El taladro cuenta con la cobertura y un buen servcio de internet para realizar las reuniones de forma virtual en la locación y así evitar aconglomeraciones', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(294, 1, 3, 17, 111, 111, 'Las casetas estan adecuadas con un sistema de correspondencia que evite que el personal requiera entrar y así evitar el contacto', '', 1.0, '');");
    await db.execute(
        "INSERT INTO requirement(id, project, factor, system, equipment, specification, label, expected, weight, comment) VALUES(295, 1, 3, 17, 111, 111, 'Existe una persona designada para la revisión del eprsonal que ingresa a la locación y que esta cuente con las pruebas de Covid-19 requeridas', '', 1.0, '');");
  }
}
