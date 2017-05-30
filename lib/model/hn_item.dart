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

  // Creates a copy of this object but with the given fields replaced with the new values.
  HnItem copyWith({
    int itemId,
    String title,
    String text,
    String type,
    bool deleted,
    int time,
    String url,
    String user,
    int score,
    int commentsCount,
    List<int> kids,
  }) {
    return new HnItem(
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      text: text ?? this.text,
      type: type ?? this.type,
      deleted: deleted ?? this.deleted,
      time: time ?? this.time,
      url: url ?? this.url,
      user: user ?? this.user,
      score: score ?? this.score,
      commentsCount: commentsCount ?? this.commentsCount,
      kids: kids ?? this.kids,
    );
  }
}

abstract class HnItemRepository {
  static Map<int, HnItem> _cache = <int, HnItem>{};

  // Abstract method to be overriden by concrete implementation
  Future<HnItem> fetch(int itemId);

  Future<HnItem> load(int itemId, [bool forceReload = false]) async {
    if (_cache.containsKey(itemId) && !forceReload) {
      return _cache[itemId];
    } else {
      final item = await fetch(itemId);
      _cache[itemId] = item;
      return item;
    }
  }

}
