import 'package:flutter_news/utils.dart';
import 'package:timeago/timeago.dart';

final fuzzy = new TimeAgo();

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

  String timeAgo;

  HnItem();

  HnItem.fromJson(Map<String, dynamic> story) {
    id = story['id'] ?? 0;
    title = story['title'] ?? '';
    user = story['by'] ?? '';
    kids = story['kids'] ?? [];
    score = story['score'] ?? 0;
    url = story['url'] ?? '';
    text = formatText(story['text'] ?? '');
    commentsCount = story['descendants'] ?? 0;
    type = story['type'] ?? 'story';
    deleted = story['deleted'] ?? false;
    time = story['time'] ?? new DateTime.now().millisecondsSinceEpoch;

    timeAgo = fuzzy.timeAgo(time * 1000);
  }

  toString() => '{id: $id, title: $title}';
}