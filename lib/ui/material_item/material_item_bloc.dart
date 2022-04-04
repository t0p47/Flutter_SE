import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_se_test/repository/material_item/material_item_repository.dart';
import 'package:flutter_se_test/ui/material_item/material_item.dart';
import 'package:bloc/bloc.dart';

class MaterialItemBloc extends Bloc<MaterialItemEvent, MaterialItemState>{
  final MaterialItemRepository materialItemRepository;

  MaterialItemBloc({@required this.materialItemRepository}) : super(MaterialItemInitial());

  /*void getNextPage(){
    dispatch(MaterialItemFetchNextPage());
  }

  void getPrevPage(){}*/

  @override
  Stream<MaterialItemState> mapEventToState(MaterialItemEvent event) async*{
    final currentState = state;
    if(event is MaterialItemInitialFromDB){
      print('MaterialItemBloc: mapEventToState: MaterialItemInitialFromDB: ${currentState.toString()}');
      try{
        if(currentState is MaterialItemInitial){
          print('MaterialItemBloc: mapEventToState: MaterialItemInitialFromDB: initialMaterial');
          final matItems = await materialItemRepository.getLastMaterials(false);
          yield MaterialItemSuccess(materialItems: matItems);
        }
      }catch(e, stacktrace){

        print('MaterialItemBloc: mapEventToState: MaterialItemInitialFromDB: MaterialItemFailure: exception ${e.toString()}, stackTrace: ${stacktrace.toString()}');
        yield MaterialItemFailure();
      }
    }
    if(event is MaterialItemFetchNextPage){
      print('MaterialItemBloc: mapEventToState: MaterialItemFetchNextPage: ${currentState.toString()}');
      try{
        if(currentState is MaterialItemInitial){
          print('MaterialItemBloc: mapEventToState: MaterialItemFetchNextPage: initialMaterial');
          final materialItems = await materialItemRepository.getLastMaterials(true);
          print('MaterialItemBloc: mapEventToState: MaterialItemFetchNextPage: initialMaterial, matItems: ${materialItems.length}');
          yield MaterialItemSuccess(materialItems: materialItems);
        }
        if(currentState is MaterialItemSuccess){
          final materialItems = await materialItemRepository.getLastMaterials(true);
          yield materialItems.isEmpty
              ? currentState.copyWith()
              : MaterialItemSuccess(
            materialItems: materialItems + currentState.materialItems,
          );
        }
      }catch(e, stacktrace){

        print('MaterialItemBloc: mapEventToState: MaterialItemFetchNextPage: MaterialItemFailure: exception ${e.toString()}, stackTrace: ${stacktrace.toString()}');
        yield MaterialItemFailure();
      }
    }
    if(event is MaterialItemGetOldPageFromDB){
      print('MaterialItemBloc: mapEventToState: MaterialItemGetOldPageFromDB: ${currentState.toString()}');
      try{
        if(currentState is MaterialItemSuccess){
          final matItems = await materialItemRepository.getPrevMaterialsDB();
          yield matItems.isEmpty
              ? currentState.copyWith()
              : MaterialItemSuccess(
            materialItems: currentState.materialItems + matItems
          );
        }
      }catch(e, stackTrace){
        print('MaterialItemBloc: mapEventToState: MaterialItemGetOldPageFromDB: MaterialItemFailure: exception ${e.toString()}, stackTrace: ${stackTrace.toString()}');
        yield MaterialItemFailure();
      }
    }
    if(event is MaterialItemGetOldPageFromServer){
      print('MaterialItemBloc: mapEventToState: MaterialItemGetOldPageFromServer: ${currentState.toString()}');
      try{
        if(currentState is MaterialItemSuccess){

          final matItems = await materialItemRepository.getPrevMaterialsServer();
          print('MaterialItemBloc: mapEventToState: MaterialItemGetOldPageFromServer: matItems length: ${matItems.length}');
          yield matItems.isEmpty
              ? currentState.copyWith()
              : MaterialItemSuccess(
              materialItems: currentState.materialItems + matItems
          );
        }
      }catch(e, stackTrace){
        print('MaterialItemBloc: mapEventToState: MaterialItemGetOldPageFromServer: MaterialItemFailure: exception ${e.toString()}, stackTrace: ${stackTrace.toString()}');
        yield MaterialItemFailure();
      }
    }
  }

}