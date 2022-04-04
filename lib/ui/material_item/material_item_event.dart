import 'package:equatable/equatable.dart';

abstract class MaterialItemEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class MaterialItemFetchNextPage extends MaterialItemEvent{

}

class MaterialItemGetOldPageFromDB extends MaterialItemEvent{

}

class MaterialItemGetOldPageFromServer extends MaterialItemEvent{

}

class MaterialItemInitialFromDB extends MaterialItemEvent{

}