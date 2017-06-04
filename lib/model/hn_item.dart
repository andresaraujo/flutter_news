import 'dart:async';

import 'package:flutter_news/utils.dart';

class HnItem {
  // API properties
  final int itemId;
  String title;
  String text;
  final String type;
  final bool deleted;
  final int time;
  final String url;
  final String user;
  final int score;
  final int commentsCount;
  final List<int> kids;
  // Helper properties
  int depthLevel;

  HnItem({
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
    this.depthLevel,
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
        time = map['time'] ?? new DateTime.now().millisecondsSinceEpoch / 1000,
        depthLevel = 1;
}

abstract class HnItemRepository {
  static Map<int, HnItem> _cache = <int, HnItem>{};

  // Abstract method to be overridden by concrete implementation
  // Fetching item from data source: db, file, etc.
  Future<HnItem> fetch(int itemId);

  Future<HnItem> load(int itemId, [bool forceReload = false]) async {
    HnItem item;
    if (_cache.containsKey(itemId) && !forceReload) {
      item = _cache[itemId];
    } else {
      item = await fetch(itemId);
      _cache[itemId] = item;
    }
    return item;
  }

  HnItem getItem(int itemId) {
    if (_cache.containsKey(itemId))
      return _cache[itemId];
    else
      return null;
  }

  void setDepthLevel(int itemId, int depthLevel) {
    if (_cache.containsKey(itemId)) {
      _cache[itemId].depthLevel = depthLevel;
    }
  }
}
