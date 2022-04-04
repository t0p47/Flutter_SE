class Enclosure{
  final int uid;
  final int sortKey;
  final String purpose;
  final String description;
  final String mediaType;
  final Variant variant;

  Enclosure({this.uid, this.sortKey, this.purpose, this.description, this.mediaType, this.variant});

  factory Enclosure.fromJson(Map<String, dynamic> parsedJson){
    return Enclosure(
      uid: parsedJson['uid'],
      sortKey: parsedJson['sortkey'],
      purpose: parsedJson['purpose'],
      description: parsedJson['description'],
      mediaType: parsedJson['mediatype'],
      variant: Variant.fromJson(parsedJson['variant'])
    );
  }

  factory Enclosure.fromDB(Map<String, dynamic> dbData){
    return Enclosure(
      mediaType:dbData['mediatype'],
      purpose: dbData['purpose'],
      description: dbData['description'],
      variant: Variant(url: dbData['url']),
    );
  }

  Map<String, dynamic> toDB() => {
    'mediatype': mediaType,
    'purpose': purpose,
    'description': description,
    'url': variant.url
  };

  /*
  * Map<String, dynamic> toJson() => {
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
  * */

}

class Variant{
  final String url;

  Variant({this.url});

  factory Variant.fromJson(Map<String, dynamic> parsedJson){
    return Variant(
      url: parsedJson['url']
    );
  }

}