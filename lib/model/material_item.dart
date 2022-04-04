import 'content.dart';
import 'enclosure.dart';

class MaterialItem{
  final String uid;
  final String mainSiteRubric;
  final String siteRubricIds;
  final String canComment;
  final String timestamp;
  final String lastSaveDate;
  final String favorite;

  final String onMainPage;
  final String color;
  final String link;
  final String title;
  final String authors;
  final String commentsAmount;
  final String materialType;
  final Content content;
  List<Enclosure> enclosures;


  MaterialItem({
    this.uid,
    this.mainSiteRubric,
    this.siteRubricIds,
    this.canComment,
    this.timestamp,
    this.lastSaveDate,
    this.favorite,

    this.onMainPage,
    this.color,
    this.link,
    this.title,
    this.authors,
    this.commentsAmount,
    this.materialType,
    this.content,
    this.enclosures
  });

  factory MaterialItem.fromJson(Map<String, dynamic> parsedJson){

    var enclosuredListParsed;
    if(parsedJson['enclosure'] != null){
      var enclosuresList = parsedJson['enclosure'] as List;
      print(enclosuresList.runtimeType);

      //print('MaterialItem: fromJson: title: ${parsedJson['title']}');
      //print('MaterialItem: fromJson: enclosure: ${parsedJson['enclosure']}');


      enclosuredListParsed = enclosuresList.map((i) => Enclosure.fromJson(i)).toList();
    }

    //print('MaterialItem: fromJson: title: ${parsedJson['title']}');
    //print('MaterialItem: fromJson: content: ${parsedJson['content']}');

    return MaterialItem(
      uid: parsedJson['uid'],
      mainSiteRubric: parsedJson['main_site_rubric'],
      siteRubricIds: parsedJson['site_rubric_ids'],
      canComment: parsedJson['comments_enable'],
      timestamp: parsedJson['timestamp'].toString(),
      lastSaveDate: parsedJson['last_save_date'].toString(),
      favorite: parsedJson['favorite'],

      onMainPage: parsedJson['on_main_page'],
      color: parsedJson['color'],
      link: parsedJson['link'],
      title: parsedJson['title'],
      authors: parsedJson['authors'],
      commentsAmount: parsedJson['comments_amount'],
      materialType: parsedJson['material_type'],
      content: parsedJson['content'] is String ? Content.fromDB(parsedJson['content']) : Content.fromJson(parsedJson['content']),
      enclosures: enclosuredListParsed
    );

  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "title": title,
    "color": color,
    "content": content.value,
    "rubric": mainSiteRubric,
    "site_rubric": siteRubricIds,
    "author": authors,
    "comment": commentsAmount,
    "can_comment": canComment,
    "timestamp": getFormattedTimestamp(),
    "last_save_date": getFormattedLastSaveDate(),
    "material_type": materialType,
    "link": link,
    "main_page": onMainPage,
    "favorite": favorite
  };

  String getFormattedTimestamp(){
    if(timestamp != null){
      //TODO: Check concatenation in Dart
      return timestamp+"000";
    }

    return null;
  }

  String getFormattedLastSaveDate(){
    if(lastSaveDate != null){
      //TODO: Check concatenation in Dart
      return lastSaveDate+"000";
    }
    return null;
  }

  /*
  * cv.put("uid", item.getUid());
    cv.put("title", item.getTitle());
    cv.put("color", item.getColor());
    cv.put("content", item.getContent().getValue());
    cv.put("rubric", item.getMainSiteRubric());
    cv.put("site_rubric", item.getSiteRubricIds());
    cv.put("author", item.getAuthors());
    cv.put("comment", item.getCommentsAmount());
    cv.put("can_comment", item.getCanComment());
    cv.put("timestamp", item.getFormattedTimestamp());
    cv.put("last_save_date", item.getFormattedLastSaveDate());
    cv.put("material_type", item.getMaterialType());
    cv.put("link", item.getLink());
    cv.put("main_page", item.getOnMainPage());
    cv.put("is_particular_sport_type", appContext.activeSportType==null? 0:1);*/

  /*
  * if (item.favorite != null){
        cv.put("favorite", item.favorite ? 1 : 0);
    }else{
        cv.put("favorite", 0);
    }
  * */

}