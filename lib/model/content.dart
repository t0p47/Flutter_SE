class Content{
  final String value;

  Content({this.value});

  factory Content.fromJson(Map<String, dynamic> parsedJson){
    return Content(
      value: parsedJson['value'],
    );
  }

  factory Content.fromDB(String value){
    return Content(
      value: value
    );
  }
}