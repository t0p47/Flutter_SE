import 'dart:async';
import 'dart:io';

import 'package:flutter_se_test/model/material_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static final String MATERIALS_TABLE = 'materials';
  static final String ENCLOSURES_TABLE = 'Enclosures';

  static Database _database;

  Future<Database> get database async{
    //print('DBProvider: get database(Check): ${_database}');
    if(_database != null) {
      //print('DBProvider: get database: not null');
      return _database;
    }

    //print('DBProvider: get database: is null');
    _database = await initDB();

    //print('DBProvider: get database(init): ${_database}');

    return _database;
  }

  initDB() async{
    //print('DBProvider: initDB');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "SeDatabase.db");

    return await openDatabase(path, version: 1, onOpen: (db){},
        onCreate: (Database db, int version) async{

          final String materialTableSQL = "create table " + MATERIALS_TABLE + " ("
              + "_id integer primary key autoincrement,"
              + "uid text NOT NULL UNIQUE,"
              + "title text,"
              + "color text,"
              + "content text,"
              + "material_type text,"
              + "rubric text,"
              + "site_rubric text,"
              + "author text,"
              + "comment text,"
              + "can_comment integer,"
              + "timestamp integer,"
              + "last_save_date integer,"
              + "link text,"
              + "favorite integer,"
              + "main_page text,"
              + "is_particular_sport_type integer"
              + ");";
          final String enclosureTableSQL = "create table " + ENCLOSURES_TABLE + " ("
              + "_id integer primary key autoincrement,"
              + "material_uid text,"
              + "mediatype text,"
              + "purpose text,"
              + "description text,"
              + "url text"
              + ");";

          await db.execute(materialTableSQL);
          await db.execute(enclosureTableSQL);
        }
    );

  }

  /*insertMaterial(MaterialItem matItem) async{
    final db = await database;
    final res = await db.insert(MATERIALS_TABLE, matItem.toJson());

    return res;
  }

  Future<List<MaterialItem>> getLatestMaterials() async{
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM $MATERIALS_TABLE");
    print('DBProvider: getLatestMaterials: $res');

    List<MaterialItem> list = res.isNotEmpty ? res.map((c) => MaterialItem.fromJson(c)).toList() : [];

    return list;
  }*/
}