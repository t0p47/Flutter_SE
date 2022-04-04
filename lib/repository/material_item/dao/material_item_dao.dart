import 'package:flutter/material.dart';
import 'package:flutter_se_test/db/DBProvider.dart';
import 'package:flutter_se_test/model/enclosure.dart';
import 'package:flutter_se_test/model/material_item.dart';

class MaterialItemDao {
  final dbProvider = DBProvider.db;

  insertMaterial(MaterialItem matItem) async {
    final db = await dbProvider.database;
    final res = await db.insert(DBProvider.MATERIALS_TABLE, matItem.toJson());
    await insertEnclosure(matItem);

    return res;
  }

  Future<List<MaterialItem>> getLatestMaterials() async {
    final db = await dbProvider.database;
    final res =
        await db.rawQuery("SELECT * FROM ${DBProvider.MATERIALS_TABLE}");
    //print('DBProvider: getLatestMaterials: $res');

    List<MaterialItem> list =
        res.isNotEmpty ? res.map((c) => MaterialItem.fromJson(c)).toList() : [];

    for(MaterialItem matItem in list){
      matItem.enclosures = await getEnclosures(matItem.uid);
    }

    print('MaterialItemDao: getLatestMaterials: enclosures length: ${list[0].enclosures.length}');

    return list;
  }

  Future<List<MaterialItem>> getPrevMaterial(String last) async{

    //List<dynamic> whereArgs = [materialId];

    final db = await dbProvider.database;

    List<dynamic> whereArgs = ['${last}000'];

    final res = await db.query(DBProvider.MATERIALS_TABLE, where: 'timestamp < ?', whereArgs: whereArgs);

    print('MaterialItemDao: getPrevMaterial: res: $res, last: $last');

    List<MaterialItem> list = res.isNotEmpty ? res.map((c) => MaterialItem.fromJson(c)).toList() : [];

    for(MaterialItem matItem in list){
      matItem.enclosures = await getEnclosures(matItem.uid);
    }

    return list;
  }

  Future<String> getLastMatItemTimeInDB() async{
    final db = await dbProvider.database;
    final res = await db.query(DBProvider.MATERIALS_TABLE, columns: ['timestamp'], orderBy: 'timestamp ASC', limit: 1);
    var defn = res.first.values.first.toString();

    //print('MaterialItemDao: getLastMatItemTimeInDB: res: ${res.toString()}, defn: $defn');

    return defn;
  }

  insertEnclosure(MaterialItem materialItem) async {
    final db = await dbProvider.database;
    //print('MaterialItemDao: insertEnclosure: ${materialItem.enclosures.length}');
    for (Enclosure enclosure in materialItem.enclosures) {
      Map<String, dynamic> enclosuresToDB =
          enclosure.toDB();


      enclosuresToDB.putIfAbsent('material_uid', () => materialItem.uid);
      //print('MaterialItemDao: insertEnclosure: ${enclosuresToDB}');

      await db.insert(DBProvider.ENCLOSURES_TABLE, enclosuresToDB);
    }
  }

  Future<List<Enclosure>> getEnclosures(String materialId) async {
    final db = await dbProvider.database;

    List<dynamic> whereArgs = [materialId];
    final res = await db.query(DBProvider.ENCLOSURES_TABLE,
        where: 'material_uid = ?', whereArgs: whereArgs);
    //print('MaterialItemDao: getEnclosures: ${res.toString()}');
    List<Enclosure> list =
        res.isNotEmpty ? res.map((c) => Enclosure.fromDB(c)).toList() : [];
    return list;
  }
}
