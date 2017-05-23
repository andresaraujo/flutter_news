import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_news/model/fetch_exception.dart';
import 'hn_story.dart';

class LiveHnStoryRepository implements HnStoryRepository {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const String _topStoriesUrl = '$_baseUrl/topstories.json';
  static const String _newStoriesUrl = '$_baseUrl/newstories.json';
  static const String _bestStoriesUrl = '$_baseUrl/beststories.json';
  static const String _showStoriesUrl = '$_baseUrl/showstories.json';
  static const String _jobStoriesUrl = '$_baseUrl/jobstories.json';
  static const String _askStoriesUrl = '$_baseUrl/askstories.json';

  final JsonDecoder _decoder = new JsonDecoder();

  @override
  Future<List<HnStory>> fetch(StoryType storyType) async {
    String _fetchUrl;

    switch (storyType) {
      case (StoryType.newest):
        _fetchUrl = _newStoriesUrl;
        break;
      case (StoryType.best):
        _fetchUrl = _bestStoriesUrl;
        break;
      case (StoryType.show):
        _fetchUrl = _showStoriesUrl;
        break;
      case (StoryType.job):
        _fetchUrl = _jobStoriesUrl;
        break;
      case (StoryType.ask):
        _fetchUrl = _askStoriesUrl;
        break;
      case (StoryType.top):
      default:
        _fetchUrl = _topStoriesUrl;
        break;
    }

    final http.Response response = await http.get(_fetchUrl);
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || response.body == null) {
      throw new FetchDataException(
          "Error while getting stories [StatusCode:$statusCode]");
    }

    final dynamic storiesContainer = _decoder.convert(response.body);
    final List<int> listStories = storiesContainer['results'];

    return listStories.map((int id) => new HnStory(storyId: id)).toList();
  }
}
