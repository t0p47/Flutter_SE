
import 'package:flutter_se_test/repository/material_item/material_item_local_data_source.dart';
import 'package:flutter_se_test/repository/material_item/material_item_remote_data_source.dart';
import 'package:flutter_se_test/repository/material_item/material_item_repository.dart';
import 'package:kiwi/kiwi.dart';
import 'package:http/http.dart' as http;

void initKiwi(){
  Container().registerFactory((c) => MaterialItemLocalDataSource());
  Container().registerFactory((c) => MaterialItemRemoteDataSource(httpClient: http.Client()));
  Container().registerFactory((c) => MaterialItemRepository(c.resolve<MaterialItemLocalDataSource>(), c.resolve<MaterialItemRemoteDataSource>()));
}