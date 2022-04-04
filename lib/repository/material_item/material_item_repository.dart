import 'package:flutter_se_test/model/enclosure.dart';
import 'package:flutter_se_test/model/material_item.dart';
import 'package:flutter_se_test/repository/material_item/dao/material_item_dao.dart';
import 'package:flutter_se_test/repository/material_item/material_item_local_data_source.dart';
import 'package:flutter_se_test/repository/material_item/material_item_remote_data_source.dart';
import 'package:http/http.dart' as http;

class MaterialItemRepository{

  final matItemDao = MaterialItemDao();


  MaterialItemLocalDataSource _localDataSource;
  MaterialItemRemoteDataSource _remoteDataSource;

  MaterialItemRepository(this._localDataSource, this._remoteDataSource);

  Future<List<MaterialItem>> getLastMaterials(bool isFromServer) async{

    print('MaterialItemRepository: getLastMaterials');

    if(isFromServer){
      await _remoteDataSource.getLastMaterials();
    }

    List<MaterialItem> matItems = await _localDataSource.getLatestMaterials();

    return matItems;
  }

  Future<List<Enclosure>> getEnclosures(String materialId) async{
    return await _localDataSource.getEnclosure(materialId);
  }

  Future<List<MaterialItem>> getPrevMaterialsServer() async{

    String lastMatItemTimeInDB = (await _localDataSource.getLastMatItemTimeInDB());
    String last = (int.parse(lastMatItemTimeInDB.substring(0, lastMatItemTimeInDB.length-3))-1).toString();

    print('MaterialItemRepository: getPrevMaterialsServer: lastMatItemTimeInDB: $last');

    await _remoteDataSource.getPrevMaterials(last);

    List<MaterialItem> matItems = await _localDataSource.getPrevMaterial(last);

    return matItems;
  }

  Future<List<MaterialItem>> getPrevMaterialsDB() async{
    String lastMatItemTimeInDB = (await _localDataSource.getLastMatItemTimeInDB());
    String last = (int.parse(lastMatItemTimeInDB.substring(0, lastMatItemTimeInDB.length-3))-1).toString();

    List<MaterialItem> matItems = await _localDataSource.getPrevMaterial(last);
    return matItems;
  }
}