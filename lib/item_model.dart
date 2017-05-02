import 'package:flutter_news/utils.dart';

class Item {
  int id;
  String title;
  String text;
  int time;
  String url;
  String user;
  int score = 0;
  int commentsCount = 0;
  List<int> kids;

  Item();

  Item.fromJson(Map<String, dynamic> story) {
    id = story['id'] ?? 0;
    title = story['title'] ?? '';
    user = story['by'] ?? '';
    kids = story['kids'] ?? [];
    score = story['score'] ?? 0;
    url = parseDomain(story['url'] ?? '');
    text = formatText(story['text'] ?? '');
    commentsCount = story['descendants'] ?? 0;
  }

  toString() => '''
  {id: $id, title: $title}
  ''';
}