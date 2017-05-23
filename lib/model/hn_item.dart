import 'dart:async';

import 'package:flutter_news/utils.dart';

class HnItem {
  final int itemId;
  final String title;
  final String text;
  final String type;
  final bool deleted;
  final int time;
  final String url;
  final String user;
  final int score;
  final int commentsCount;
  final List<int> kids;

  const HnItem({
    this.itemId,
    this.title,
    this.text,
    this.type,
    this.deleted,
    this.url,
    this.user,
    this.score,
    this.commentsCount,
    this.kids,
    this.time,
  });

  HnItem.fromMap(Map<String, dynamic> map)
      : itemId = map['id'],
        title = map['title'] ?? '',
        user = map['by'] ?? '',
        kids = map['kids'] ?? <int>[],
        score = map['score'] ?? 0,
        url = map['url'] ?? '',
        text = formatText(map['text'] ?? ''),
        commentsCount = map['descendants'] ?? 0,
        type = map['type'] ?? 'story',
        deleted = map['deleted'] ?? false,
        time = map['time'] ?? new DateTime.now().millisecondsSinceEpoch / 1000;
}

abstract class HnItemRepository {
  Future<HnItem> fetch(int itemId);
}
