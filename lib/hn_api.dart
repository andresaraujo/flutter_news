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

Future<HnItem> getHnItem(int itemId) async {
  assert(itemId != null);

  final String url =
      _debugMode ? '$_itemUrl/$itemId' : '$_itemUrl/$itemId.json';
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(url);

  final Map<String, dynamic> story = _jsonCodec.decode(response.body);

  return new HnItem.fromJson(story);
}

Future<List<int>> _getStoryIds(String storiesUrl) async {
  assert(storiesUrl != null);

  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(storiesUrl);

  final List<int> listStories = _jsonCodec.decode(response.body);

  return listStories;
}

Future<List<int>> getTopStoryIds() => _getStoryIds(_topStoriesUrl);

Future<List<int>> getNewStoryIds() => _getStoryIds(_newStoriesUrl);

Future<List<int>> getShowStoryIds() => _getStoryIds(_showStoriesUrl);

Future<List<int>> getAskStoryIds() => _getStoryIds(_askStoriesUrl);

Future<List<int>> getJobStoryIds() => _getStoryIds(_jobStoriesUrl);

Future<List<HnItem>> getComments(List<int> ids) async {
  final Iterable<Future<HnItem>> futures =
      ids.take(5).map((int id) => getHnItem(id));
  return Future.wait(futures);
}
