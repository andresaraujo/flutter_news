import 'package:flutter_news/utils.dart';
import 'package:timeago/timeago.dart';

final TimeAgo fuzzy = new TimeAgo();

class HnItem {
  // Hacker News API: https://github.com/HackerNews/API

  int id;
  String title = "";
  String text = "";
  String type = "";
  bool deleted = false;
  int time = 0;
  String url = "";
  String user = "";
  int score = 0;
  int commentsCount = 0;
  List<int> kids = <int>[];

  String timeAgo = "";

  HnItem();

  HnItem.fromJson(Map<String, dynamic> story) {
    id = story['id'] ?? 0;
    title = story['title'] ?? '';
    user = story['by'] ?? '';
    kids = story['kids'] ?? <int>[];
    score = story['score'] ?? 0;
    url = story['url'] ?? '';
    text = formatText(story['text'] ?? '');
    commentsCount = story['descendants'] ?? 0;
    type = story['type'] ?? 'story';
    deleted = story['deleted'] ?? false;
    time = story['time'] ?? new DateTime.now().millisecondsSinceEpoch / 1000;

    timeAgo =
        fuzzy.format(new DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  @override
  String toString() => '{id: $id, title: $title}';
}
