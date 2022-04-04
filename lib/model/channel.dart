import 'news.dart';

class Channel{
  News news;

  Channel({this.news});

  factory Channel.fromJson(Map<String, dynamic> parsedJson){
    return Channel(
      news: News.fromJson(parsedJson['news'])
    );
  }
}