import 'material_item.dart';

class News{
  final int totalItems;
  final List<MaterialItem> materials;

  News({this.totalItems, this.materials});

  factory News.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['materials'] as List;
    print("News: list runType: "+list.runtimeType.toString());
    List<MaterialItem> materialsList = list.map((i) => MaterialItem.fromJson(i)).toList();

    return News(
      totalItems: parsedJson['totalitems'],
      materials: materialsList
    );
  }


}