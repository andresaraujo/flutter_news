// Implementation of Hacker News API
// https://github.com/HackerNews/API

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/utils.dart';
import 'package:http/http.dart';
import 'package:timeago/timeago.dart';

const bool _debugMode = false;

const String _baseUrl = _debugMode
    ? 'http://localhost:3000'
    : 'https://hacker-news.firebaseio.com/v0';
const String _topStoriesUrl = '$_baseUrl/topstories.json';
const String _newStoriesUrl = '$_baseUrl/newstories.json';
//const String _bestStoriesUrl = '$_baseUrl/beststories.json';
const String _showStoriesUrl = '$_baseUrl/showstories.json';
const String _jobStoriesUrl = '$_baseUrl/jobstories.json';
const String _askStoriesUrl = '$_baseUrl/askstories.json';

const JsonCodec jsonCodec = const JsonCodec();

class HnApi {
  HnApi();

  static Future<List<int>> _getStoryIds(String storiesUrl) async {
    assert(storiesUrl != null);

    final Client httpClient = createHttpClient();
    final Response response = await httpClient.get(storiesUrl);

    final List<int> listStories = jsonCodec.decode(response.body);

    return listStories;
  }

  static Future<List<int>> getTopStoryIds() => _getStoryIds(_topStoriesUrl);

  static Future<List<int>> getNewStoryIds() => _getStoryIds(_newStoriesUrl);

  static Future<List<int>> getShowStoryIds() => _getStoryIds(_showStoriesUrl);

  static Future<List<int>> getAskStoryIds() => _getStoryIds(_askStoriesUrl);

  static Future<List<int>> getJobStoryIds() => _getStoryIds(_jobStoriesUrl);

  static Future<List<HnItem>> getComments(List<int> ids) async {
    final Iterable<Future<HnItem>> futures = ids.take(5).map((int id) {
      return new HnItem(id).fetch();
    });
    return Future.wait(futures);
  }
}

class HnItem {
  static const String _itemUrl = '$_baseUrl/item';

  static final Map<int, HnItem> _cache = <int, HnItem>{};

  final TimeAgo fuzzyTime = new TimeAgo();

  int id;
  bool cached;
  String title;
  String text;
  String type;
  bool deleted;
  int time;
  String url;
  String user;
  int score;
  int commentsCount;
  List<int> kids;
  String timeAgo;

  factory HnItem(int itemId) {
    assert(itemId != null);

    if (_cache.containsKey(itemId)) {
      return _cache[itemId];
    } else {
      final HnItem hnItem = new HnItem._internal(itemId);
      _cache[itemId] = hnItem;
      return hnItem;
    }
  }

  HnItem._internal(int itemId)
      : id = itemId,
        cached = false,
        title = "",
        text = "",
        type = "",
        deleted = false,
        time = 0,
        url = "",
        user = "",
        score = 0,
        commentsCount = 0,
        kids = <int>[],
        timeAgo = "";

  // Fetch item data and update current instance
  Future<HnItem> fetch() async {
    final String fetchUrl = _debugMode ? '$_itemUrl/$id' : '$_itemUrl/$id.json';
    final Client httpClient = createHttpClient();
    final Response response = await httpClient.get(fetchUrl);

    final Map<String, dynamic> item = jsonCodec.decode(response.body);

    cached = true;
    title = item['title'] ?? '';
    user = item['by'] ?? '';
    kids = item['kids'] ?? <int>[];
    score = item['score'] ?? 0;
    url = item['url'] ?? '';
    text = formatText(item['text'] ?? '');
    commentsCount = item['descendants'] ?? 0;
    type = item['type'] ?? 'story';
    deleted = item['deleted'] ?? false;
    time = item['time'] ?? new DateTime.now().millisecondsSinceEpoch / 1000;
    timeAgo =
        fuzzyTime.format(new DateTime.fromMillisecondsSinceEpoch(time * 1000));

    _cache[item['id']] = this;

    return this;
  }

  @override
  String toString() => '{id: $id, title: $title}';
}
