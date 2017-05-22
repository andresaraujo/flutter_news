// Implementation of Hacker News API
// https://github.com/HackerNews/API

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/item_model.dart';
import 'package:http/http.dart';

class HnApi {
  static const bool _debugMode = false;

  static const String _baseUrl = _debugMode
      ? 'http://localhost:3000'
      : 'https://hacker-news.firebaseio.com/v0';
  static const String _topStoriesUrl = '$_baseUrl/topstories.json';
  static const String _newStoriesUrl = '$_baseUrl/newstories.json';
  //static const String _bestStoriesUrl = '$_baseUrl/beststories.json';
  static const String _showStoriesUrl = '$_baseUrl/showstories.json';
  static const String _jobStoriesUrl = '$_baseUrl/jobstories.json';
  static const String _askStoriesUrl = '$_baseUrl/askstories.json';
  static const String _itemUrl = '$_baseUrl/item';

  static const JsonCodec _jsonCodec = const JsonCodec();

  static final Map<int, HnItem> _itemCache = <int, HnItem>{};

  HnApi();

  static Future<HnItem> getHnItem(int itemId) async {
    assert(itemId != null);

    if (_itemCache.containsKey(itemId)) {
      return new Future<HnItem>.value(_itemCache[itemId]);
    }

    final String url =
    _debugMode ? '$_itemUrl/$itemId' : '$_itemUrl/$itemId.json';
    final Client httpClient = createHttpClient();
    final Response response = await httpClient.get(url);

    final Map<String, dynamic> story = _jsonCodec.decode(response.body);

    final HnItem hnItem = new HnItem.fromJson(story);
    _itemCache[story['id']] = hnItem;

    return hnItem;
  }

  static Future<List<int>> _getStoryIds(String storiesUrl) async {
    assert(storiesUrl != null);

    final Client httpClient = createHttpClient();
    final Response response = await httpClient.get(storiesUrl);

    final List<int> listStories = _jsonCodec.decode(response.body);

    return listStories;
  }

  static Future<List<int>> getTopStoryIds() => _getStoryIds(_topStoriesUrl);

  static Future<List<int>> getNewStoryIds() => _getStoryIds(_newStoriesUrl);

  static Future<List<int>> getShowStoryIds() => _getStoryIds(_showStoriesUrl);

  static Future<List<int>> getAskStoryIds() => _getStoryIds(_askStoriesUrl);

  static Future<List<int>> getJobStoryIds() => _getStoryIds(_jobStoriesUrl);

  static Future<List<HnItem>> getComments(List<int> ids) async {
    final Iterable<Future<HnItem>> futures =
    ids.take(5).map((int id) => getHnItem(id));
    return Future.wait(futures);
  }

}



