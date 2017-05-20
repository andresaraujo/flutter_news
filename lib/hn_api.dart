// Implementation of Hacker News API
// https://github.com/HackerNews/API

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/item_model.dart';
import 'package:http/http.dart';

const bool _debugMode = false;

const String _baseUrl = _debugMode
    ? 'http://localhost:3000'
    : 'https://hacker-news.firebaseio.com/v0';
const String _topStoriesUrl = '$_baseUrl/topstories.json';
const String _newStoriesUrl = '$_baseUrl/newstories.json';
const String _bestStoriesUrl = '$_baseUrl/beststories.json';
const String _showStoriesUrl = '$_baseUrl/showstories.json';
const String _jobStoriesUrl = '$_baseUrl/jobstories.json';
const String _askStoriesUrl = '$_baseUrl/askstories.json';
const String _itemUrl = '$_baseUrl/item';

// Max. number of stories for New, Top and Best
const int _storyLimit1 = 500;

// Max. number of stories for Ask, Show and Job
const int _storyLimit2 = 200;

const JsonCodec _jsonCodec = const JsonCodec();

Future<HnItem> _getItem(int itemId) async {
  final Client httpClient = createHttpClient();

  final String url =
      _debugMode ? '$_itemUrl/$itemId' : '$_itemUrl/$itemId.json';
  final Response response = await httpClient.get(url);

  final Map<String, dynamic> story = _jsonCodec.decode(response.body);

  return new HnItem.fromJson(story);
}

Future<List<HnItem>> _getStories(String storiesUrl,
    {int from = 0, int count = 10, int limit = _storyLimit2}) async {
  // Input sanity check
  assert(storiesUrl != null);
  assert(from >= 0);
  assert(count >= 0);

  // Make sure we will not get over max. story count
  if (count > limit) count = limit;
  if ((from + count) > limit) count = limit - from;

  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(storiesUrl);

  final List<int> listStories = _jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> stories =
      listStories.skip(from).take(count).map((int id) => _getItem(id));
  return Future.wait(stories);
}

Future<List<HnItem>> getTopStories({int from = 0, int count = 10}) async =>
    _getStories(_topStoriesUrl, from: from, count: count, limit: _storyLimit1);

Future<List<HnItem>> getNewStories({int from = 0, int count = 10}) async =>
    _getStories(_newStoriesUrl, from: from, count: count, limit: _storyLimit1);

Future<List<HnItem>> getShowStories({int from = 0, int count = 10}) async =>
    _getStories(_showStoriesUrl, from: from, count: count, limit: _storyLimit2);

Future<List<HnItem>> getAskStories({int from = 0, int count = 10}) async =>
    _getStories(_askStoriesUrl, from: from, count: count, limit: _storyLimit2);

Future<List<HnItem>> getJobStories({int from = 0, int count = 10}) async =>
    _getStories(_jobStoriesUrl, from: from, count: count, limit: _storyLimit2);

Future<List<HnItem>> getComments(List<int> ids) async {
  final Iterable<Future<HnItem>> futures =
      ids.take(5).map((int id) => _getItem(id));
  return Future.wait(futures);
}
