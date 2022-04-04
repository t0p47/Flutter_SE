import 'package:equatable/equatable.dart';
import 'package:flutter_se_test/model/material_item.dart';

abstract class MaterialItemState extends Equatable{
  const MaterialItemState();

  @override
  List<Object> get props => [];
}

class MaterialItemInitial extends MaterialItemState{

}

class MaterialItemFailure extends MaterialItemState{

}

class MaterialItemSuccess extends MaterialItemState{
  final List<MaterialItem> materialItems;

  const MaterialItemSuccess({
    this.materialItems
  });

  MaterialItemSuccess copyWith({
    List<MaterialItem> materialItems
  }){
    return MaterialItemSuccess(
      materialItems: materialItems ?? this.materialItems
    );
  }

  @override
  List<Object> get props => [materialItems];

  @override
  String toString() => 'MaterialItem success { materialItems: ${materialItems.length}';
}