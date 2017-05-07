import 'package:flutter_news/utils.dart';

class HnItem {
  int id;
  String title;
  String text;
  String type;
  bool deleted;
  int time;
  String url;
  String user;
  int score = 0;
  int commentsCount = 0;
  List<int> kids;

  HnItem();

  HnItem.fromJson(Map<String, dynamic> story) {
    id = story['id'] ?? 0;
    title = story['title'] ?? '';
    user = story['by'] ?? '';
    kids = story['kids'] ?? [];
    score = story['score'] ?? 0;
    url = parseDomain(story['url'] ?? '');
    text = formatText(story['text'] ?? '');
    commentsCount = story['descendants'] ?? 0;
    type = story['type'] ?? 'story';
    deleted = story['deleted'] ?? false;
  }

  toString() => '''
  {id: $id, title: $title}
  ''';
}