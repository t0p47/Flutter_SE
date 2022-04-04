import 'package:flutter_se_test/db/DBProvider.dart';
import 'package:flutter_se_test/model/enclosure.dart';
import 'package:flutter_se_test/model/material_item.dart';

import 'dao/material_item_dao.dart';

class MaterialItemLocalDataSource{

  final matItemDao = MaterialItemDao();

  Future<List<MaterialItem>> getLatestMaterials() async{
    //return DBProvider.db.getLatestMaterials();
    return matItemDao.getLatestMaterials();
  }

  Future<List<MaterialItem>> getPrevMaterial(String last) async{
    return matItemDao.getPrevMaterial(last);
  }

  Future<String> getLastMatItemTimeInDB() async{
    return matItemDao.getLastMatItemTimeInDB();
  }

  Future<List<Enclosure>> getEnclosure(String materialId) async{
    //return DBProvider.db.getLatestMaterials();
    return matItemDao.getEnclosures(materialId);
  }

}